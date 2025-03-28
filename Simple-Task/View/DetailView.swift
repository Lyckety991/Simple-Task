//
//  DetailView.swift
//  Simple-Task
//
//  Created by Patrick Lanham on 09.02.25.
//
import SwiftUI

struct DetailView: View {
    @ObservedObject var viewModel: TaskViewModel
    let task: PrivateTask
    @Environment(\.dismiss) private var dismiss

    @State private var title: String
    @State private var description: String
    @State private var date: Date
    @State private var category: TaskCategory

    init(viewModel: TaskViewModel, task: PrivateTask) {
        self.viewModel = viewModel
        self.task = task
        _title = State(initialValue: task.title ?? "")
        _description = State(initialValue: task.desc ?? "")
        _date = State(initialValue: task.date ?? Date())
        _category = State(initialValue: task.taskCategory)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Titel")) {
                    TextField("Notiz Titel eingeben", text: $title)
                }

                Section(header: Text("Beschreibung")) {
                    TextEditor(text: $description)
                        .frame(minHeight: 100)
                }

                Section(header: Text("Datum")) {
                    DatePicker("Datum auswählen", selection: $date, displayedComponents: .date)
                }

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
                    viewModel.updateTask(
                        task,
                        title: title,
                        desc: description,
                        isInCalendar: task.isInCalendar,
                        date: date
                    )
                    task.taskCategory = category // Kategorie direkt aktualisieren
                    viewModel.saveContext()
                    dismiss()
                }
            )
        }
    }
}


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
