//
//  DetailView.swift
//  Simple-Task
//
//  Created by Patrick Lanham on 09.02.25.
//
import SwiftUI

struct DetailView: View {
    @ObservedObject var viewModel: TaskViewModel
    @Binding var task: PrivateTask
    @Environment(\.presentationMode) var presentationMode

    @State private var title: String
    @State private var description: String
    @State private var date: Date

    init(viewModel: TaskViewModel, task: Binding<PrivateTask>) {
        self.viewModel = viewModel
        self._task = task
        self._title = State(initialValue: task.wrappedValue.title ?? "")
        self._description = State(initialValue: task.wrappedValue.desc ?? "")
        self._date = State(initialValue: task.wrappedValue.date ?? Date())
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Titel")) {
                    TextField("Notiz Titel eingeben", text: $title)
                }

                Section(header: Text("Beschreibung")) {
                    TextEditor(text: $description)
                        .frame(minHeight: 100) // Dynamische Höhe
                        
                }

                Section(header: Text("Datum")) {
                    DatePicker("Datum auswählen", selection: $date, displayedComponents: .date)
                }
            }
            .navigationTitle("Notiz bearbeiten")
            .navigationBarItems(
                leading: Button("Abbrechen") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Speichern") {
                    saveChanges()
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }

    private func saveChanges() {
        viewModel.updateTask(task, title: title, desc: description, isInCalendar: task.isInCalendar, date: date)
    }
}

#Preview {
    let dataModel = TaskDataModel.preview
    let viewModel = TaskViewModel(manager: dataModel)

   
}
