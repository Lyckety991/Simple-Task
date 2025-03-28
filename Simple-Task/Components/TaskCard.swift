import SwiftUI

struct TaskCard: View {
    let task: PrivateTask
    var onDelete: (PrivateTask) -> Void
    @State private var showingAlert = false

    var body: some View {
        HStack(spacing: 0) {
            // Farbstreifen links, passend zur Kategorie
            Rectangle()
                .fill(task.taskCategory.color)
                .frame(width: 6)
                .cornerRadius(3, corners: [.topRight, .bottomRight])

            VStack(alignment: .leading, spacing: 5) {
                // Titel & Löschen-Button
                HStack {
                    Text(task.title ?? "Kein Titel")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Button(action: {
                        showingAlert = true
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(
                            title: Text("Notiz löschen?"),
                            message: Text("Bist du sicher, dass du diese Notiz löschen möchtest?"),
                            primaryButton: .destructive(Text("Löschen")) {
                                onDelete(task)
                            },
                            secondaryButton: .cancel(Text("Abbruch"))
                        )
                    }
                }

                // Beschreibung (falls vorhanden)
                if let desc = task.desc, !desc.isEmpty {
                    Text(desc)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                // Datum + Kategorie unten
                HStack {
                    if let date = task.date {
                        Label(formatDate(date), systemImage: "calendar")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    Label(task.taskCategory.rawValue, systemImage: task.taskCategory.symbol)
                        .font(.caption)
                        .foregroundColor(task.taskCategory.color)
                }
            }
            .padding()
            .background(Color(UIColor.systemGray6))
        }
        .cornerRadius(10)
        .shadow(radius: 3)
    }

    // Datum formatieren
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}


#Preview {
    let task = PrivateTask(context: TaskDataModel.preview.persistentContainer.viewContext)
    task.title = "Wichtige Aufgabe"
    task.desc = "Diese Aufgabe muss erledigt werden."
    task.date = Date()
    task.category = TaskCategory.wichtig.rawValue

    return TaskCard(task: task) { _ in }
}
