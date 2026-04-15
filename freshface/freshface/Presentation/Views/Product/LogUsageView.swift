import SwiftUI

struct LogUsageView: View {
    let product: Product
    let onSave: (UsageLog) -> Void

    @Environment(\.dismiss) var dismiss
    @State private var notes = ""
    @State private var skinCondition = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Log Usage")) {
                    TextField("Notes (optional)", text: $notes, axis: .vertical)
                        .lineLimit(3...6)

                    TextField("Skin Condition (optional)", text: $skinCondition, axis: .vertical)
                        .lineLimit(2...4)
                }

                Section(header: Text("Summary")) {
                    HStack {
                        Text("Product")
                        Spacer()
                        Text(product.name)
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("Time")
                        Spacer()
                        Text(Date().formatted(date: .abbreviated, time: .shortened))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Log Usage")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let log = UsageLog(
                            productId: product.id,
                            notes: notes.isEmpty ? nil : notes,
                            skinCondition: skinCondition.isEmpty ? nil : skinCondition
                        )
                        onSave(log)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    LogUsageView(product: Product.sampleData[0]) { _ in }
}
