import SwiftUI

struct AddProductView: View {
    @StateObject private var viewModel: AddProductViewModel
    @Environment(\.dismiss) var dismiss

    init(repository: ProductRepositoryProtocol) {
        _viewModel = StateObject(wrappedValue: AddProductViewModel(repository: repository))
    }

    var body: some View {
        NavigationStack {
            Form {
                imageSection

                basicInfoSection

                barcodeSection

                dateAndPAOSection

                additionalInfoSection
            }
            .navigationTitle("Add Product")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if viewModel.saveProduct() != nil {
                            dismiss()
                        }
                    }
                    .disabled(!viewModel.isValidForm || viewModel.isSaving)
                }
            }
            .sheet(isPresented: $viewModel.showScanner) {
                BarcodeScannerView { barcode in
                    viewModel.barcode = barcode
                    Task {
                        await viewModel.lookupProduct(barcode: barcode)
                    }
                }
            }
            .sheet(isPresented: $viewModel.showImagePicker) {
                ImagePicker(image: Binding(
                    get: { nil },
                    set: { image in
                        if let image {
                            viewModel.setImage(image)
                        }
                    }
                ))
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") {}
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }

    private var imageSection: some View {
        Section(header: Text("Product Image")) {
            if let imageData = viewModel.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 150)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 40))
                            .foregroundColor(.gray.opacity(0.3))
                    )
            }

            Button(action: { viewModel.showImagePicker = true }) {
                Label(viewModel.imageData != nil ? "Change Photo" : "Add Photo",
                      systemImage: viewModel.imageData != nil ? "camera" : "photo")
            }
        }
    }

    private var barcodeSection: some View {
        Section(header: Text("Barcode (Optional)")) {
            HStack {
                TextField("Enter barcode", text: Binding(
                    get: { viewModel.barcode ?? "" },
                    set: { viewModel.barcode = $0.isEmpty ? nil : $0 }
                ))
                .keyboardType(.numberPad)

                Button(action: { viewModel.showScanner = true }) {
                    Image(systemName: "viewfinder")
                        .font(.title2)
                        .foregroundColor(Color(hex: "FF6B9D"))
                }
            }
        }
    }

    private var basicInfoSection: some View {
        Section(header: Text("Basic Information")) {
            TextField("Product Name *", text: $viewModel.name)
                .textFieldStyle(.roundedBorder)

            TextField("Brand (Optional)", text: $viewModel.brand)
                .textFieldStyle(.roundedBorder)

            Picker("Category *", selection: $viewModel.category) {
                ForEach(ProductCategory.allCases, id: \.self) { category in
                    Text(category.displayName).tag(category)
                }
            }

            Picker("Type (Optional)", selection: $viewModel.productType) {
                Text("None").tag(nil as ProductType?)
                ForEach(ProductType.allCases, id: \.self) { type in
                    Text(type.displayName).tag(type as ProductType?)
                }
            }
        }
    }

    private var dateAndPAOSection: some View {
        Section(header: Text("Date & Expiry")) {
            DatePicker("Date Opened",
                       selection: $viewModel.openDate,
                       displayedComponents: .date)

            Picker("PAO (Period After Opening)", selection: $viewModel.paoMonths) {
                Text("3 months").tag(3)
                Text("6 months").tag(6)
                Text("12 months").tag(12)
                Text("18 months").tag(18)
                Text("24 months").tag(24)
                Text("36 months").tag(36)
            }

            DatePicker("Purchase Date (Optional)",
                       selection: Binding(
                           get: { viewModel.purchaseDate ?? Date() },
                           set: { viewModel.purchaseDate = $0 }
                       ),
                       displayedComponents: .date)
        }
    }

    private var additionalInfoSection: some View {
        Section(header: Text("Additional Information")) {
            Stepper("Usage Frequency: \(viewModel.usageFrequency)x per week",
                    value: $viewModel.usageFrequency,
                    in: 1...14)

            TextField("Notes (Optional)", text: $viewModel.notes, axis: .vertical)
                .lineLimit(3...6)
                .textFieldStyle(.roundedBorder)
        }
    }
}

#Preview {
    AddProductView(repository: MockProductRepository())
}
