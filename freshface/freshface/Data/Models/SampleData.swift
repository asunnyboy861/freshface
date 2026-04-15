import Foundation

extension Product {
    static var sampleData: [Product] {
        let calendar = Calendar.current
        
        return [
            Product(
                name: "CeraVe Hydrating Facial Cleanser",
                brand: "CeraVe",
                category: .skincare,
                productType: .cleanser,
                purchaseDate: calendar.date(byAdding: .day, value: -30, to: Date()),
                openDate: calendar.date(byAdding: .day, value: -15, to: Date()),
                paoMonths: 12,
                usageFrequency: 2,
                estimatedRemaining: 0.7
            ),
            
            Product(
                name: "La Roche-Posay Anthelios Sunscreen",
                brand: "La Roche-Posay",
                category: .skincare,
                productType: .sunscreen,
                purchaseDate: calendar.date(byAdding: .day, value: -60, to: Date()),
                openDate: calendar.date(byAdding: .day, value: -45, to: Date()),
                paoMonths: 6,
                usageFrequency: 7,
                estimatedRemaining: 0.4
            ),
            
            Product(
                name: "The Ordinary Niacinamide Serum",
                brand: "The Ordinary",
                category: .skincare,
                productType: .serum,
                purchaseDate: calendar.date(byAdding: .day, value: -90, to: Date()),
                openDate: calendar.date(byAdding: .day, value: -80, to: Date()),
                paoMonths: 12,
                usageFrequency: 3,
                estimatedRemaining: 0.5
            ),
            
            Product(
                name: "Maybelline Instant Age Rewind Concealer",
                brand: "Maybelline",
                category: .makeup,
                productType: .concealer,
                purchaseDate: calendar.date(byAdding: .month, value: -6, to: Date()),
                openDate: calendar.date(byAdding: .month, value: -5, to: Date()),
                paoMonths: 6,
                usageFrequency: 14,
                estimatedRemaining: 0.2
            ),
            
            Product(
                name: "Dior Sauvage Eau de Toilette",
                brand: "Dior",
                category: .fragrance,
                productType: .perfume,
                purchaseDate: calendar.date(byAdding: .year, value: -1, to: Date()),
                openDate: calendar.date(byAdding: .month, value: -10, to: Date()),
                paoMonths: 36,
                usageFrequency: 1,
                estimatedRemaining: 0.6
            ),
            
            Product(
                name: "Olaplex No. 3 Hair Perfector",
                brand: "Olaplex",
                category: .haircare,
                productType: .conditioner,
                purchaseDate: calendar.date(byAdding: .month, value: -3, to: Date()),
                openDate: calendar.date(byAdding: .weekOfYear, value: -2, to: Date()),
                paoMonths: 12,
                usageFrequency: 1,
                estimatedRemaining: 0.9
            ),
            
            Product(
                name: "Neutrogena Hydro Boost Water Gel",
                brand: "Neutrogena",
                category: .skincare,
                productType: .moisturizer,
                purchaseDate: calendar.date(byAdding: .day, value: -10, to: Date()),
                openDate: calendar.date(byAdding: .day, value: -5, to: Date()),
                paoMonths: 12,
                usageFrequency: 2,
                estimatedRemaining: 0.95
            ),
            
            Product(
                name: "Lancôme Advanced Génifique Serum",
                brand: "Lancôme",
                category: .skincare,
                productType: .serum,
                purchaseDate: calendar.date(byAdding: .month, value: -12, to: Date()),
                openDate: calendar.date(byAdding: .month, value: -11, to: Date()),
                paoMonths: 18,
                usageFrequency: 2,
                estimatedRemaining: 0.3
            )
        ]
    }
}
