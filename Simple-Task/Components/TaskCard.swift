//
//  TaskCard.swift
//  Simple-Task
//
//  Created by Patrick Lanham on 11.02.25.
//
import SwiftUI

struct TaskCard: View {
    let task: PrivateTask
    var onDelete: (PrivateTask) -> Void
    @State private var showingAlert = false

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(task.title ?? "Kein Titel")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
 
                // Löschen-Button mit Alert-Abfrage
                Button(action: {
                    showingAlert = true // Zeigt den Alert an
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text("Notiz löschen?"),
                        message: Text("Bist du sicher, dass du diese Notiz löschen möchtest?"),
                        primaryButton: .destructive(Text("Löschen")) {
                            onDelete(task) // Task wirklich löschen
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

            // Datum unten rechts anzeigen
            if let date = task.date {
                HStack {
                    Text(formatDate(date))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.systemGray6))
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

// ✅ **Richtige Preview mit funktionierender `onDelete`-Funktion**
#Preview {
    let previewTask = PrivateTask(context: TaskDataModel.preview.persistentContainer.viewContext)
    previewTask.title = "Beispiel-Aufgabe"
    previewTask.desc = "Dies ist eine lange Beschreibung, um die dynamische Größe zu testen."
    previewTask.date = Date()

    return TaskCard(
        task: previewTask,
        onDelete: { _ in print("Task gelöscht") } // Simulierter Löschprozess
    )
}
