import SwiftUI

struct RoutineListView: View {
    @State private var routines: [Routine] = []
    @State private var showAddRoutine = false
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showRoutineGuide = false

    private let repository = LocalRoutineRepository()

    var body: some View {
        NavigationStack {
            routineContent
                .navigationTitle("Routines")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: { showAddRoutine = true }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showAddRoutine) {
                    AddRoutineView { newRoutine in
                        addRoutine(newRoutine)
                    }
                }
                .refreshable {
                    await loadRoutines()
                }
        }
        .onAppear {
            Task { await loadRoutines() }
        }
        .alert("Error", isPresented: .constant(errorMessage != nil)) {
            Button("OK") { errorMessage = nil }
        } message: {
            Text(errorMessage ?? "")
        }
    }

    private var routineContent: some View {
        Group {
            if isLoading && routines.isEmpty {
                ProgressView("Loading routines...")
                    .padding()
            } else if let error = errorMessage, routines.isEmpty {
                ErrorStateView(message: error) {
                    Task { await loadRoutines() }
                }
            } else if routines.isEmpty {
                emptyStateView
            } else {
                routineList
            }
        }
    }

    private var emptyStateView: some View {
        EnhancedEmptyStateView(
            title: "No Routines",
            message: "Create your morning or evening skincare routine",
            systemImage: "sunrise.fill",
            primaryActionTitle: "Create Routine",
            primaryAction: { showAddRoutine = true },
            secondaryActionTitle: "Learn More",
            secondaryAction: { showRoutineGuide = true },
            showTip: true,
            tipText: "Tip: Organize products by application order!"
        )
        .sheet(isPresented: $showRoutineGuide) {
            ContextualHelpView(
                title: "Creating Routines",
                steps: [
                    "Tap '+' to create new routine",
                    "Choose morning or evening routine type",
                    "Add skincare steps in correct order",
                    "Assign products to each step",
                    "Set timing for each step (optional)",
                    "Save and start tracking your routine"
                ]
            )
        }
    }

    private var routineList: some View {
        List {
            ForEach(routines) { routine in
                NavigationLink(destination: RoutineDetailView(routine: routine)) {
                    RoutineRowView(routine: routine)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        deleteRoutine(routine)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
    }

    private func loadRoutines() async {
        isLoading = true
        do {
            routines = try await repository.fetchAll()
        } catch {
            await MainActor.run {
                errorMessage = "Failed to load routines: \(error.localizedDescription)"
            }
        }
        await MainActor.run {
            isLoading = false
        }
    }

    private func addRoutine(_ routine: Routine) {
        Task {
            do {
                let created = try await repository.create(routine)
                await MainActor.run {
                    routines.append(created)
                }
            } catch {
                await MainActor.run {
                    errorMessage = "Failed to create routine: \(error.localizedDescription)"
                }
            }
        }
    }

    private func deleteRoutine(_ routine: Routine) {
        Task {
            do {
                try await repository.delete(routine)
                await MainActor.run {
                    routines.removeAll { $0.id == routine.id }
                }
            } catch {
                await MainActor.run {
                    errorMessage = "Failed to delete routine: \(error.localizedDescription)"
                }
            }
        }
    }
}

struct RoutineRowView: View {
    let routine: Routine

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: routine.routineType.icon)
                .font(.title2)
                .foregroundColor(Color(hex: "FF6B9D"))
                .frame(width: 40, height: 40)
                .background(Color(hex: "FF6B9D").opacity(0.1))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(routine.name)
                    .font(.headline)

                HStack(spacing: 6) {
                    Text(routine.routineType.displayName)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(6)

                    if let time = routine.time {
                        Text(time.formatted(date: .omitted, time: .shortened))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }

            Spacer()

            if routine.isActive {
                Circle()
                    .fill(Color.green)
                    .frame(width: 10, height: 10)
            } else {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 10, height: 10)
            }
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    RoutineListView()
}
