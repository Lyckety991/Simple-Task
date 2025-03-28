//
//  TaskViewModel.swift
//  Simple-Task
//
//  Created by Patrick Lanham on 18.01.25.
//
import Foundation
import CoreData
import UIKit

class TaskViewModel: ObservableObject {
    let manager: TaskDataModel
    @Published var task: [PrivateTask] = []
    @Published var isDataLoaded = false
    @Published var errorMessage: String?

    init(manager: TaskDataModel) {
        self.manager = manager
        loadData()
    }

    func loadData() {
        DispatchQueue.global(qos: .background) .async {
            self.manager.loadCoreData { [weak self] result in
                DispatchQueue.main.async {
                    self?.isDataLoaded = result
                    self?.fetchTask()
                }
        }
       
        }
    }
    
    func createTask(title: String, desc: String, date: Date, category: String) {
        let newTask = PrivateTask(context: manager.persistentContainer.viewContext)
        newTask.id = UUID()
        newTask.title = title
        newTask.desc = desc
        newTask.date = date
        newTask.category = category
        saveContext()
        fetchTask() // UI aktualisieren
    }


    func fetchTask(with searchText: String = "", isDone: Bool? = nil) {
        let request: NSFetchRequest<PrivateTask> = PrivateTask.fetchRequest()
        var predicates: [NSPredicate] = []

        if !searchText.isEmpty {
            predicates.append(NSPredicate(format: "title CONTAINS[cd] %@", searchText))
        }

        if let isDone = isDone {
            predicates.append(NSPredicate(format: "isDone == %@", NSNumber(value: isDone)))
        }

        if !predicates.isEmpty {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }

        do {
            task = try manager.persistentContainer.viewContext.fetch(request)
        } catch {
            print("Error fetching tasks: \(error.localizedDescription)")
            errorMessage = "Failed to fetch tasks."
        }
    }
    
    func deleteTask(_ task: PrivateTask) {
        let context = manager.persistentContainer.viewContext
        context.delete(task)
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
        
        do {
            try context.save() // Änderungen in CoreData speichern
            fetchTask() // UI aktualisieren
           
        } catch {
            print("Fehler beim Löschen der Aufgabe: \(error.localizedDescription)")
        }
    }


    func updateTask(_ task: PrivateTask, title: String, desc: String, isInCalendar: Bool, date: Date) {
        task.title = title
        task.desc = desc
        task.isInCalendar = isInCalendar
        task.date = date
        saveContext()
        fetchTask() // Daten neu laden
    }

    func saveContext() {
        let context = manager.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                errorMessage = "Fehler beim Speichern: \(error.localizedDescription)"
            }
        }
    }

}
