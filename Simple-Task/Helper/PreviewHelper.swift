//
//  PreviewHelper.swift
//  Simple-Task
//
//  Created by Patrick Lanham on 28.03.25.
//

import Foundation
import CoreData
import Combine

/// Hilfsklasse zur Bereitstellung von Beispielinhalten für SwiftUI-Previews.
/// Enthält Beispiel-Tasks, ein ViewModel mit InMemory-CoreData und ein Mock-ViewModel.
struct PreviewHelper {
    
    /// Beispiel-ViewModel mit `TaskDataModel.preview` für Previews.
    static var viewModel: TaskViewModel {
        TaskViewModel(manager: TaskDataModel.preview)
    }

    /// Eine einzelne Beispiel-Aufgabe mit vollständigen Feldern.
    static var sampleTask: PrivateTask {
        let context = TaskDataModel.preview.viewContext
        let task = PrivateTask(context: context)
        task.id = UUID()
        task.title = "Wichtige Notiz"
        task.desc = "Dies ist eine Notiz für die Vorschau."
        task.date = Date()
        task.category = TaskCategory.wichtig.rawValue
        task.isInCalendar = false
        return task
    }

    /// Eine Liste von mehreren Beispiel-Aufgaben für Listenansichten.
    static var multipleTasks: [PrivateTask] {
        let context = TaskDataModel.preview.viewContext
        let samples: [(String, TaskCategory)] = [
            ("Arbeit", .arbeit),
            ("Privat", .privat),
            ("Sonstiges", .sonstiges),
            ("🔥 Wichtig!", .wichtig)
        ]

        return samples.map { title, category in
            let task = PrivateTask(context: context)
            task.id = UUID()
            task.title = title
            task.desc = "Beispielbeschreibung für \(title)"
            task.date = Date().addingTimeInterval(Double.random(in: -10000...10000))
            task.category = category.rawValue
            return task
        }
    }

    // MARK: - Mock ViewModel für Previews & UI-Tests

    /// Simuliertes ViewModel ohne echten CoreData-Zugriff.
    /// Perfekt für SwiftUI-Previews oder schnelle UI-Tests.
    final class MockTaskViewModel: ObservableObject {
        @Published var task: [PrivateTask] = []
        @Published var isDataLoaded = true
        @Published var errorMessage: String?

        /// Erstellt ein Mock-ViewModel mit optional vordefinierten Aufgaben.
        init(tasks: [PrivateTask] = PreviewHelper.multipleTasks) {
            self.task = tasks
        }

        /// Kein echter Datenzugriff – simuliert nur Ladezustand.
        func loadData() {}

        /// Fügt eine neue Aufgabe hinzu – rein lokal.
        func createTask(title: String, desc: String, date: Date, category: TaskCategory) {
            let newTask = PrivateTask(context: TaskDataModel.preview.viewContext)
            newTask.id = UUID()
            newTask.title = title
            newTask.desc = desc
            newTask.date = date
            newTask.category = category.rawValue
            task.append(newTask)
        }

        /// Entfernt eine Aufgabe anhand der ID – simuliert echtes Löschen.
        func deleteTask(_ taskToDelete: PrivateTask) {
            task.removeAll { $0.id == taskToDelete.id }
        }

        /// Aktualisiert eine bestehende Aufgabe im lokalen Array.
        func updateTask(_ taskToUpdate: PrivateTask, title: String, desc: String, isInCalendar: Bool, date: Date) {
            guard let index = task.firstIndex(where: { $0.id == taskToUpdate.id }) else { return }
            task[index].title = title
            task[index].desc = desc
            task[index].date = date
        }

        func fetchTask() {
            // Optional: Filter, Suche, etc.
        }

        func saveContext() {
            // Kein Persistenzverhalten im Mock
        }
    }
}
