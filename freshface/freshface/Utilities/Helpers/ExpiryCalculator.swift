import Foundation

struct ExpiryCalculator {
    
    static func calculateExpiryDate(openDate: Date, paoMonths: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: paoMonths, to: openDate) ?? openDate
    }
    
    static func daysRemaining(until expiryDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: expiryDate)
        return components.day ?? 0
    }
    
    static func riskLevel(daysRemaining: Int) -> RiskLevel {
        if daysRemaining <= 0 {
            return .expired
        } else if daysRemaining <= 3 {
            return .critical
        } else if daysRemaining <= 7 {
            return .warning
        } else if daysRemaining <= 30 {
            return .caution
        } else {
            return .safe
        }
    }
}

struct CompletionPrediction {
    let willFinish: Bool
    let usageRate: Double
    let recommendedUsagesPerWeek: Int
    
    static func predict(
        usageFrequency: Int?,
        estimatedRemaining: Double?,
        daysRemaining: Int?
    ) -> CompletionPrediction? {
        
        guard let usageFrequency,
              let estimatedRemaining,
              let daysRemaining,
              daysRemaining > 0 else { return nil }
        
        let weeksRemaining = Double(daysRemaining) / 7.0
        let estimatedUsages = Double(usageFrequency) * weeksRemaining
        
        let averageProductUsages = 50.0
        let remainingUsages = averageProductUsages * estimatedRemaining
        
        let willFinish = estimatedUsages >= remainingUsages
        let usageRate = remainingUsages > 0 ? estimatedUsages / remainingUsages : 0
        
        let recommendedUsages = weeksRemaining > 0 ? Int(ceil(remainingUsages / weeksRemaining)) : 0
        
        return CompletionPrediction(
            willFinish: willFinish,
            usageRate: usageRate,
            recommendedUsagesPerWeek: recommendedUsages
        )
    }
}
