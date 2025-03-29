//
//  DetailView.swift
//  Simple-Task
//
//  Created by Patrick Lanham on 09.02.25.
//
import SwiftUI

/// Detailansicht zur Bearbeitung einer bestehenden Aufgabe.
/// Unterstützt das Ändern von Titel, Beschreibung, Datum und Kategorie.
struct DetailView: View {
    @ObservedObject var viewModel: TaskViewModel
    let task: PrivateTask

    @Environment(\.dismiss) private var dismiss

    // Temporäre States für die Formularfelder
    @State private var title: String
    @State private var description: String
    @State private var date: Date
    @State private var category: TaskCategory
    @State private var reminderOffset: TimeInterval

    /// Initialisiert die DetailView mit dem aktuellen Stand der Aufgabe.
    init(viewModel: TaskViewModel, task: PrivateTask) {
        self.viewModel = viewModel
        self.task = task
        _title = State(initialValue: task.title ?? "")
        _description = State(initialValue: task.desc ?? "")
        _date = State(initialValue: task.date ?? Date())
        _category = State(initialValue: task.taskCategory)
        _reminderOffset = State(initialValue: task.reminderOffset)
    }

    var body: some View {
        NavigationStack {
            Form {
                // Titel bearbeiten
                Section(header: Text("Titel")) {
                    TextField("Notiz Titel eingeben", text: $title)
                }

                // Beschreibung bearbeiten
                Section(header: Text("Beschreibung")) {
                    TextEditor(text: $description)
                        .frame(minHeight: 100)
                }

                // Datum bearbeiten
                Section(header: Text("Datum")) {
                    DatePicker("Datum auswählen", selection: $date, displayedComponents: .date)
                    Picker("Wann erinnern?", selection: $reminderOffset) {
                           Text("Keine Erinnerung").tag(0.0)
                           Text("Zur Fälligkeit").tag(0.1)
                           Text("5 Minuten vorher").tag(-300.0)
                           Text("30 Minuten vorher").tag(-1800.0)
                           Text("1 Stunde vorher").tag(-3600.0)
                           Text("1 Tag vorher").tag(-86400.0)
                       }
                       .pickerStyle(MenuPickerStyle())
                    
                }

                // Kategorie auswählen
                Section(header: Text("Kategorie")) {
                    Picker("Kategorie", selection: $category) {
                        ForEach(TaskCategory.allCases) { cat in
                            Label(cat.rawValue, systemImage: cat.symbol).tag(cat)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationTitle("Notiz bearbeiten")
            .navigationBarItems(
                leading: Button("Abbrechen") {
                    dismiss()
                },
                trailing: Button("Speichern") {
                    // Änderungen an das ViewModel übergeben
                    viewModel.updateTask(
                        task,
                        title: title,
                        desc: description,
                        isInCalendar: task.isInCalendar,
                        date: date
                    )

                    // Zusätzliche Änderungen direkt am Task-Objekt
                    task.taskCategory = category
                    task.reminderOffset = reminderOffset

                    // Falls Erinnerung gewünscht → Notification planen
                    if reminderOffset != 0 {
                        let reminderDate = date.addingTimeInterval(reminderOffset)
                        NotificationManager.shared.scheduleNotification(
                            title: title,
                            body: "Fällig um \(formatDate(date))",
                            at: reminderDate
                        )
                    }

                    // Änderungen speichern
                    viewModel.saveContext()
                    dismiss()
                }

            )
        }
    }
}

// Vorschau mit Testdaten für SwiftUI Canvas
#Preview {
    let context = TaskDataModel.preview.persistentContainer.viewContext
    let sampleTask = PrivateTask(context: context)
    sampleTask.id = UUID()
    sampleTask.title = "Preview-Titel"
    sampleTask.desc = "Vorschau-Beschreibung"
    sampleTask.date = Date()
    sampleTask.category = TaskCategory.wichtig.rawValue

    let viewModel = TaskViewModel(manager: TaskDataModel.preview)

    return DetailView(viewModel: viewModel, task: sampleTask)
}
