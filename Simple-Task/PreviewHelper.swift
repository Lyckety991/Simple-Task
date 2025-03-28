//
//  PreviewHelper.swift
//  Simple-Task
//
//  Created by Patrick Lanham on 28.03.25.
//

import Foundation
import CoreData
import Combine

/// Eine Hilfsklasse für Vorschau-Zwecke in SwiftUI
struct PreviewHelper {
    
    /// Beispiel-ViewModel mit InMemory Core Data Stack
    static var viewModel: TaskViewModel {
        TaskViewModel(manager: TaskDataModel.preview)
    }

    /// Beispiel-Aufgabe mit allen Feldern
    static var sampleTask: PrivateTask {
        let context = TaskDataModel.preview.persistentContainer.viewContext
        let task = PrivateTask(context: context)
        task.id = UUID()
        task.title = "Wichtige Notiz"
        task.desc = "Dies ist eine Notiz für die Vorschau."
        task.date = Date()
        task.category = TaskCategory.wichtig.rawValue
        task.isInCalendar = false
        return task
    }

    /// Mehrere Beispiel-Aufgaben (z. B. für Listen)
    static var multipleTasks: [PrivateTask] {
        let context = TaskDataModel.preview.persistentContainer.viewContext
        return [
            ("Arbeit", TaskCategory.arbeit),
            ("Privat", TaskCategory.privat),
            ("Sonstiges", TaskCategory.sonstiges),
            ("🔥 Wichtig!", TaskCategory.wichtig)
        ].map { title, category in
            let task = PrivateTask(context: context)
            task.id = UUID()
            task.title = title
            task.desc = "Beispielbeschreibung für \(title)"
            task.date = Date().addingTimeInterval(Double.random(in: -10000...10000))
            task.category = category.rawValue
            return task
        }
    }
    
    
    

    // MARK: - Mock ViewModel für Previews & Tests
    final class MockTaskViewModel: ObservableObject {
        @Published var task: [PrivateTask] = []
        @Published var isDataLoaded = true
        @Published var errorMessage: String? = nil

        init(tasks: [PrivateTask] = PreviewHelper.multipleTasks) {
            self.task = tasks
        }

        func loadData() {
            // Kein CoreData, nur lokale Tasks – optional simulieren
        }

        func createTask(title: String, desc: String, date: Date, category: TaskCategory) {
            let newTask = PrivateTask(context: TaskDataModel.preview.viewContext)
            newTask.id = UUID()
            newTask.title = title
            newTask.desc = desc
            newTask.date = date
            newTask.category = category.rawValue
            task.append(newTask)
        }

        func deleteTask(_ taskToDelete: PrivateTask) {
            task.removeAll { $0.id == taskToDelete.id }
        }

        func updateTask(_ taskToUpdate: PrivateTask, title: String, desc: String, isInCalendar: Bool, date: Date) {
            guard let index = task.firstIndex(where: { $0.id == taskToUpdate.id }) else { return }
            task[index].title = title
            task[index].desc = desc
            task[index].date = date
        }

        func fetchTask() {
            // Optional für spätere Filter
        }

        func saveContext() {
            // No-op im Mock
        }
    }

    
}

