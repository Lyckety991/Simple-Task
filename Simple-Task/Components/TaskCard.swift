import SwiftUI

/// Visuelle Darstellung einer einzelnen Aufgabe.
/// Zeigt Titel, Beschreibung, Datum und Kategorie.
/// Enthält Farbakzent und Löschfunktion mit Bestätigung.
struct TaskCard: View {
    let task: PrivateTask
    var onDelete: (PrivateTask) -> Void
    @State private var showingAlert = false

    var body: some View {
        HStack(spacing: 0) {
            // Farbstreifen links – passend zur Kategorie
            Rectangle()
                .fill(task.taskCategory.color)
                .frame(width: 6)
                .cornerRadius(3, corners: [.topRight, .bottomRight])

            VStack(alignment: .leading, spacing: 8) {
                // Titel und Löschen-Button
                HStack(alignment: .top) {
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
                            secondaryButton: .cancel(Text("Abbrechen"))
                        )
                    }
                }

                // Beschreibung anzeigen, falls vorhanden
                if let desc = task.desc, !desc.trimmingCharacters(in: .whitespaces).isEmpty {
                    Text(desc)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                // Datum & Kategorie (z. B. unten rechts)
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
        .accessibilityElement(children: .combine)
    }

    /// Formatierter Datumstext (medium style, lokalisiert)
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy - HH:mm"
        return formatter.string(from: date)
    }
}

// Preview mit Beispielaufgabe
#Preview {
    let task = PrivateTask(context: TaskDataModel.preview.persistentContainer.viewContext)
    task.title = "Wichtige Aufgabe"
    task.desc = "Diese Aufgabe muss erledigt werden."
    task.date = Date()
    task.category = TaskCategory.wichtig.rawValue

    return TaskCard(task: task) { _ in }
        .padding()
        .previewLayout(.sizeThatFits)
}
