import SwiftUI

struct AddRoutineView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var selectedType: RoutineType = .morning
    @State private var reminderTime = Date()
    @State private var isActive = true
    @State private var isSaving = false
    @State private var errorMessage: String?

    let onSave: (Routine) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Routine Details")) {
                    TextField("Routine Name", text: $name)

                    Picker("Type", selection: $selectedType) {
                        ForEach(RoutineType.allCases, id: \.self) { type in
                            Label(type.displayName, systemImage: type.icon).tag(type)
                        }
                    }
                }

                Section(header: Text("Reminder")) {
                    DatePicker("Reminder Time",
                               selection: $reminderTime,
                               displayedComponents: .hourAndMinute)

                    Toggle("Active", isOn: $isActive)
                }
            }
            .navigationTitle("New Routine")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveRoutine()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty || isSaving)
                }
            }
            .alert("Error", isPresented: .constant(errorMessage != nil)) {
                Button("OK") { errorMessage = nil }
            } message: {
                Text(errorMessage ?? "")
            }
            .overlay {
                if isSaving {
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.2))
                }
            }
        }
    }

    private func saveRoutine() {
        isSaving = true

        let routine = Routine(
            name: name.trimmingCharacters(in: .whitespaces),
            routineType: selectedType,
            time: reminderTime,
            isActive: isActive
        )

        Task {
            do {
                let created = try await CloudRoutineRepository().create(routine)
                await MainActor.run {
                    onSave(created)
                    isSaving = false
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    errorMessage = "Failed to save routine: \(error.localizedDescription)"
                    isSaving = false
                }
            }
        }
    }
}

#Preview {
    AddRoutineView { routine in
        print("Created routine: \(routine.name)")
    }
}
