import SwiftUI

struct RoutineStepEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedProductId: UUID?
    @State private var stepName: String = ""
    @State private var waitTimeMinutes: Int = 0
    @State private var waitTimeSeconds: Int = 0
    @State private var notes: String = ""

    let step: RoutineStep?
    let availableProducts: [Product]
    let onSave: (RoutineStep) -> Void

    init(
        step: RoutineStep? = nil,
        availableProducts: [Product],
        onSave: @escaping (RoutineStep) -> Void
    ) {
        self.step = step
        self.availableProducts = availableProducts
        self.onSave = onSave

        if let step = step {
            _selectedProductId = State(initialValue: step.productId)
            _stepName = State(initialValue: step.productName)
            _waitTimeMinutes = State(initialValue: (step.waitTimeSeconds ?? 0) / 60)
            _waitTimeSeconds = State(initialValue: (step.waitTimeSeconds ?? 0) % 60)
            _notes = State(initialValue: step.notes ?? "")
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Product")) {
                    Picker("Select Product", selection: $selectedProductId) {
                        Text("None").tag(nil as UUID?)
                        ForEach(availableProducts) { product in
                            HStack {
                                Image(systemName: product.category.icon)
                                Text(product.name)
                            }
                            .tag(product.id as UUID?)
                        }
                    }
                }

                Section(header: Text("Step Details")) {
                    TextField("Step Name", text: $stepName)
                        .onChange(of: selectedProductId) { _, newValue in
                            if stepName.isEmpty || step == nil {
                                if let product = availableProducts.first(where: { $0.id == newValue }) {
                                    stepName = product.name
                                }
                            }
                        }

                    HStack {
                        Text("Wait Time")
                        Spacer()
                        Picker("Minutes", selection: $waitTimeMinutes) {
                            ForEach(0..<60, id: \.self) { minute in
                                Text("\(minute) min").tag(minute)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 100, height: 100)
                        .clipped()

                        Picker("Seconds", selection: $waitTimeSeconds) {
                            ForEach(0..<60, id: \.self) { second in
                                Text("\(second) sec").tag(second)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 100, height: 100)
                        .clipped()
                    }
                }

                Section(header: Text("Notes")) {
                    TextEditor(text: $notes)
                        .frame(minHeight: 80)
                }
            }
            .navigationTitle(step == nil ? "Add Step" : "Edit Step")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveStep()
                    }
                    .disabled(stepName.isEmpty)
                }
            }
        }
    }

    private func saveStep() {
        let totalWaitSeconds = (waitTimeMinutes * 60) + waitTimeSeconds
        let waitTime: Int? = totalWaitSeconds > 0 ? totalWaitSeconds : nil

        let newStep = RoutineStep(
            id: step?.id ?? UUID(),
            productId: selectedProductId,
            productName: stepName,
            stepOrder: step?.stepOrder ?? 0,
            waitTimeSeconds: waitTime,
            isCompleted: step?.isCompleted ?? false,
            notes: notes.isEmpty ? nil : notes
        )

        onSave(newStep)
        dismiss()
    }
}

#Preview {
    RoutineStepEditorView(
        availableProducts: [],
        onSave: { _ in }
    )
}
