import SwiftUI

/// Safety score card
/// Displays overall product safety score and rating
struct SafetyScoreCard: View {
    let score: ProductSafetyScore
    
    var body: some View {
        VStack(spacing: 20) {
            // Large score display
            ZStack {
                Circle()
                    .stroke(Color(hex: score.rating.color).opacity(0.2), lineWidth: 12)
                    .frame(width: 140, height: 140)
                
                Circle()
                    .trim(from: 0, to: CGFloat(score.overallScore) / 100)
                    .stroke(
                        Color(hex: score.rating.color),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .frame(width: 140, height: 140)
                    .rotationEffect(.degrees(-90))
                
                VStack(spacing: 4) {
                    Text("\(score.overallScore)")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(Color(hex: score.rating.color))
                    
                    Text("/100")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Rating label
            Text(score.rating.displayName)
                .font(.title3.bold())
                .foregroundColor(Color(hex: score.rating.color))
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(Color(hex: score.rating.color).opacity(0.1))
                .cornerRadius(20)
            
            // Clean label
            if score.isClean {
                HStack(spacing: 6) {
                    Image(systemName: "leaf.fill")
                        .foregroundColor(.green)
                    Text("Clean Beauty")
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.green)
                }
            }
            
            // Recommendation text
            Text(score.recommendation)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(24)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
}

// MARK: - Concerns Section

struct ConcernsSection: View {
    let concerns: [SafetyConcern]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
                Text("Key Concerns")
                    .font(.headline)
            }
            
            VStack(spacing: 8) {
                ForEach(concerns, id: \.self) { concern in
                    HStack(spacing: 12) {
                        Image(systemName: concern.icon)
                            .foregroundColor(.orange)
                            .frame(width: 24)
                        
                        Text(concern.rawValue)
                            .font(.subheadline)
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color.orange.opacity(0.05))
                    .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Ingredients Breakdown Section

struct IngredientsBreakdownSection: View {
    let breakdown: [IngredientScoreDetail]
    let unrecognized: [String]
    @State private var expandedIngredients: Set<String> = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Ingredient Breakdown")
                    .font(.headline)
                
                Spacer()
                
                Text("\(breakdown.count) analyzed")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            VStack(spacing: 8) {
                ForEach(breakdown.prefix(10), id: \.name) { detail in
                    IngredientRow(detail: detail, isExpanded: expandedIngredients.contains(detail.name))
                        .onTapGesture {
                            withAnimation {
                                if expandedIngredients.contains(detail.name) {
                                    expandedIngredients.remove(detail.name)
                                } else {
                                    expandedIngredients.insert(detail.name)
                                }
                            }
                        }
                }
            }
            
            if !unrecognized.isEmpty {
                DisclosureGroup("\(unrecognized.count) unrecognized ingredients") {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(unrecognized, id: \.self) { name in
                            Text("• \(name)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.top, 8)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

struct IngredientRow: View {
    let detail: IngredientScoreDetail
    let isExpanded: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                // Safety indicator
                Circle()
                    .fill(Color(hex: detail.rating.color))
                    .frame(width: 12, height: 12)
                
                Text(detail.name)
                    .font(.subheadline.weight(.medium))
                
                Spacer()
                
                Text("\(detail.score)")
                    .font(.caption.bold())
                    .foregroundColor(Color(hex: detail.rating.color))
                
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 6) {
                    if !detail.concerns.isEmpty {
                        HStack(spacing: 6) {
                            ForEach(detail.concerns, id: \.self) { concern in
                                Text(concern.rawValue)
                                    .font(.caption2)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(Color.orange.opacity(0.1))
                                    .foregroundColor(.orange)
                                    .cornerRadius(4)
                            }
                        }
                    }
                    
                    Text("Listed as: \(detail.rawText)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.leading, 24)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}
