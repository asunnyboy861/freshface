import SwiftUI

struct RoutineStepRowView: View {
    let step: RoutineStep
    let stepNumber: Int
    let onToggleComplete: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            stepIndicator

            VStack(alignment: .leading, spacing: 4) {
                Text(step.productName)
                    .font(.headline)
                    .strikethrough(step.isCompleted)
                    .foregroundColor(step.isCompleted ? .secondary : .primary)

                if let waitTime = step.waitTimeFormatted {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.caption)
                        Text("Wait \(waitTime)")
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                }

                if let notes = step.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            Button(action: onToggleComplete) {
                Image(systemName: step.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(step.isCompleted ? Color(hex: "FF6B9D") : .secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 8)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive, action: onDelete) {
                Label("Delete", systemImage: "trash")
            }
        }
    }

    private var stepIndicator: some View {
        ZStack {
            Circle()
                .fill(
                    step.isCompleted
                        ? Color(hex: "FF6B9D")
                        : Color(.systemGray4)
                )
                .frame(width: 32, height: 32)

            if step.isCompleted {
                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            } else {
                Text("\(stepNumber)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    let sampleStep = RoutineStep(
        productName: "Vitamin C Serum",
        stepOrder: 1,
        waitTimeSeconds: 60,
        notes: "Wait for full absorption"
    )

    return RoutineStepRowView(
        step: sampleStep,
        stepNumber: 1,
        onToggleComplete: {},
        onDelete: {}
    )
    .padding()
}
