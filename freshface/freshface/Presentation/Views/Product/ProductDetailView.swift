import SwiftUI

struct ProductDetailView: View {
    @StateObject private var viewModel: ProductDetailViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showDeleteConfirmation = false
    @State private var showLogUsageSheet = false
    @State private var showIngredientAnalysis = false
    @State private var usageLogs: [UsageLog] = []

    private let usageLogRepository = CloudUsageLogRepository()

    init(product: Product) {
        _viewModel = StateObject(wrappedValue: ProductDetailViewModel(
            product: product,
            repository: LocalProductRepository()
        ))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                productImageView
                productInfoSection
                expiryStatusSection
                ingredientAnalysisSection
                completionPredictionSection
                usageSection
                actionsSection
            }
            .padding()
        }
        .sheet(isPresented: $showIngredientAnalysis) {
            IngredientAnalysisView(product: viewModel.product)
        }
        .navigationTitle(viewModel.product.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }

                    Button(action: { showLogUsageSheet = true }) {
                        Label("Log Usage", systemImage: "plus.circle")
                    }

                    Button(action: viewModel.markAsUsed) {
                        Label("Mark as Used", systemImage: "checkmark.circle")
                    }

                    Button(action: shareProduct) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showLogUsageSheet) {
            LogUsageView(product: viewModel.product) { log in
                logUsage(log)
            }
        }
        .alert("Delete Product", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                Task {
                    try? await viewModel.deleteProduct()
                    dismiss()
                }
            }
        } message: {
            Text("Are you sure you want to delete \(viewModel.product.name)? This action cannot be undone.")
        }
        .task {
            await loadUsageLogs()
        }
    }
    
    private var productImageView: some View {
        Group {
            if let imageData = viewModel.product.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.1))
                    .overlay(
                        Image(systemName: viewModel.product.category.icon)
                            .font(.system(size: 50))
                            .foregroundColor(.gray.opacity(0.3))
                    )
            }
        }
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
    }
    
    private var productInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let brand = viewModel.product.brand {
                InfoRow(label: "Brand", value: brand)
            }
            
            InfoRow(label: "Category", value: viewModel.product.category.displayName)
            
            if let type = viewModel.product.productType {
                InfoRow(label: "Type", value: type.displayName)
            }
            
            if let openDate = viewModel.product.openDate {
                InfoRow(label: "Opened", value: openDate.formatted(date: .abbreviated, time: .omitted))
            }
            
            if let pao = viewModel.product.paoMonths {
                InfoRow(label: "PAO", value: "\(pao) months")
            }
            
            if let notes = viewModel.product.notes, !notes.isEmpty {
                InfoRow(label: "Notes", value: notes)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private var expiryStatusSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Expiry Status")
                .font(.headline)
            
            if let risk = viewModel.riskLevel,
               let days = viewModel.daysRemaining {
                HStack(spacing: 12) {
                    Circle()
                        .fill(Color(hex: risk.color))
                        .frame(width: 20, height: 20)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(risk.rawValue.uppercased())
                            .font(.subheadline.bold())
                            .foregroundColor(Color(hex: risk.color))
                        
                        Text(days <= 0
                             ? "This product has expired"
                             : days == 1
                             ? "Expires in \(days) day"
                             : "Expires in \(days) days")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: risk.icon)
                        .font(.title2)
                        .foregroundColor(Color(hex: risk.color))
                }
                .padding()
                .background(Color(hex: risk.color).opacity(0.1))
                .cornerRadius(12)
            } else {
                Text("Expiry date not set")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    // MARK: - Ingredient Analysis Section
    private var ingredientAnalysisSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ingredient Analysis")
                .font(.headline)
            
            if let ingredients = viewModel.product.ingredients, !ingredients.isEmpty {
                // Has ingredients - show analysis entry
                Button(action: { showIngredientAnalysis = true }) {
                    HStack(spacing: 16) {
                        Image(systemName: "magnifyingglass.circle.fill")
                            .font(.title2)
                            .foregroundColor(Color(hex: "FF6B9D"))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("View Analysis")
                                .font(.subheadline.weight(.medium))
                            
                            Text("Check safety rating and potential concerns")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(hex: "FF6B9D").opacity(0.05))
                    .cornerRadius(12)
                }
                .buttonStyle(.plain)
            } else {
                // No ingredients - show add entry
                Button(action: { showIngredientAnalysis = true }) {
                    HStack(spacing: 16) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.green)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Add Ingredients")
                                .font(.subheadline.weight(.medium))
                            
                            Text("Analyze product safety and get recommendations")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.green.opacity(0.05))
                    .cornerRadius(12)
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private var completionPredictionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Completion Prediction")
                .font(.headline)

            if let prediction = viewModel.completionPrediction {
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: prediction.willFinish ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(prediction.willFinish ? .green : .orange)

                        Text(prediction.willFinish
                             ? "You can finish this product before it expires!"
                             : "You may not finish before expiry")
                            .font(.subheadline.bold())
                    }

                    if prediction.recommendedUsagesPerWeek > 0 {
                        Text("Recommended usage: \(prediction.recommendedUsagesPerWeek)x per week")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
            }
        }
    }

    private var usageSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Usage History")
                    .font(.headline)
                Spacer()
                Button(action: { showLogUsageSheet = true }) {
                    Label("Log Usage", systemImage: "plus.circle")
                        .font(.subheadline)
                }
            }

            if usageLogs.isEmpty {
                Text("No usage logged yet. Tap 'Log Usage' to record when you use this product.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            } else {
                ForEach(usageLogs.prefix(5)) { log in
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text(log.date.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption)
                        Spacer()
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }

    private func logUsage(_ log: UsageLog) {
        Task {
            do {
                _ = try await usageLogRepository.create(log)
                await loadUsageLogs()
            } catch {
                print("Error logging usage: \(error)")
            }
        }
    }

    private func loadUsageLogs() async {
        do {
            usageLogs = try await usageLogRepository.fetch(for: viewModel.product.id)
        } catch {
            print("Error loading usage logs: \(error)")
        }
    }

    private var actionsSection: some View {
        VStack(spacing: 12) {
            Button(action: viewModel.saveChanges) {
                HStack {
                    Spacer()
                    Text("Save Changes")
                        .font(.headline)
                    Spacer()
                }
                .padding()
                .background(Color(hex: "FF6B9D"))
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(viewModel.isSaving)
        }
    }
    
    private func shareProduct() {
        let text = "Check out my skincare product: \(viewModel.product.name)"
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline.bold())
        }
    }
}

#Preview {
    NavigationStack {
        ProductDetailView(product: Product.sampleData[0])
    }
}
