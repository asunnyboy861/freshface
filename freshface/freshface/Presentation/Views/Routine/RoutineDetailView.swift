import SwiftUI

struct RoutineDetailView: View {
    @State var routine: Routine
    @State private var showAddStep = false
    @State private var editingStep: RoutineStep?
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var availableProducts: [Product] = []

    private let repository = CloudRoutineRepository()

    var body: some View {
        List {
            infoSection

            stepsSection

            addStepButton
        }
        .listStyle(.insetGrouped)
        .navigationTitle(routine.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { showAddStep = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddStep) {
            RoutineStepEditorView(
                step: nil,
                availableProducts: availableProducts
            ) { newStep in
                addStep(newStep)
            }
        }
        .sheet(item: $editingStep) { step in
            RoutineStepEditorView(
                step: step,
                availableProducts: availableProducts
            ) { updatedStep in
                updateStep(updatedStep)
            }
        }
        .alert("Error", isPresented: .constant(errorMessage != nil)) {
            Button("OK") { errorMessage = nil }
        } message: {
            Text(errorMessage ?? "")
        }
        .task {
            await loadAvailableProducts()
        }
    }

    private func loadAvailableProducts() async {
        do {
            availableProducts = try await CloudProductRepository().fetchAll()
                .filter { $0.isActive }
                .sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
        } catch {
            print("Error loading products: \(error)")
        }
    }

    private var infoSection: some View {
        Section {
            HStack {
                Image(systemName: routine.routineType.icon)
                    .font(.title2)
                    .foregroundColor(Color(hex: "FF6B9D"))
                    .frame(width: 40, height: 40)
                    .background(Color(hex: "FF6B9D").opacity(0.1))
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 4) {
                    Text(routine.name)
                        .font(.headline)

                    Text(routine.routineType.displayName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                if routine.isActive {
                    Label("Active", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }

            if let time = routine.time {
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.secondary)
                    Text(time.formatted(date: .omitted, time: .shortened))
                        .font(.subheadline)
                }
            }
        }
    }

    private var stepsSection: some View {
        Section(header: Text("Steps (\(routine.steps.count))")) {
            if routine.steps.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "list.bullet")
                        .font(.system(size: 40))
                        .foregroundColor(.gray.opacity(0.3))

                    Text("No Steps Yet")
                        .font(.headline)

                    Text("Add your first step to build your routine")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
                .listRowBackground(Color.clear)
            } else {
                ForEach(Array(routine.steps.enumerated()), id: \.element.id) { index, step in
                    RoutineStepRowView(
                        step: step,
                        stepNumber: index + 1,
                        onToggleComplete: { toggleStep(step) },
                        onDelete: { deleteStep(step) }
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        editingStep = step
                    }
                }
                .onMove(perform: moveSteps)
            }
        }
    }

    private var addStepButton: some View {
        Section {
            Button(action: { showAddStep = true }) {
                Label("Add Step", systemImage: "plus.circle.fill")
                    .foregroundColor(Color(hex: "FF6B9D"))
            }
        }
    }

    private func addStep(_ step: RoutineStep) {
        var newStep = step
        newStep.stepOrder = routine.steps.count
        routine.steps.append(newStep)
        saveRoutine()
    }

    private func updateStep(_ step: RoutineStep) {
        if let index = routine.steps.firstIndex(where: { $0.id == step.id }) {
            routine.steps[index] = step
            saveRoutine()
        }
    }

    private func deleteStep(_ step: RoutineStep) {
        routine.steps.removeAll { $0.id == step.id }
        reorderSteps()
        saveRoutine()
    }

    private func toggleStep(_ step: RoutineStep) {
        if let index = routine.steps.firstIndex(where: { $0.id == step.id }) {
            routine.steps[index].isCompleted.toggle()
            saveRoutine()
        }
    }

    private func moveSteps(from source: IndexSet, to destination: Int) {
        routine.steps.move(fromOffsets: source, toOffset: destination)
        reorderSteps()
        saveRoutine()
    }

    private func reorderSteps() {
        for (index, _) in routine.steps.enumerated() {
            routine.steps[index].stepOrder = index
        }
    }

    private func saveRoutine() {
        isLoading = true
        Task {
            do {
                let updated = try await repository.update(routine)
                await MainActor.run {
                    self.routine = updated
                }
            } catch {
                await MainActor.run {
                    errorMessage = "Failed to save: \(error.localizedDescription)"
                }
            }
            await MainActor.run {
                isLoading = false
            }
        }
    }
}

#Preview {
    NavigationStack {
        RoutineDetailView(
            routine: Routine(
                name: "Morning Skincare",
                routineType: .morning,
                time: Date(),
                steps: [
                    RoutineStep(productName: "Cleanser", stepOrder: 0),
                    RoutineStep(productName: "Toner", stepOrder: 1, waitTimeSeconds: 30),
                    RoutineStep(productName: "Vitamin C Serum", stepOrder: 2)
                ]
            )
        )
    }
}
