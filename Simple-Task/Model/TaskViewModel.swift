//
//  TaskViewModel.swift
//  Simple-Task
//
//  Created by Patrick Lanham on 18.01.25.
//
import Foundation
import CoreData
import UIKit


/// ViewModel zur Verwaltung von Aufgaben.
/// Beinhaltet Logik für das Erstellen, Laden, Löschen und Aktualisieren von Aufgaben.
/// Synchronisiert automatisch mit CoreData und dem Widget-System.
class TaskViewModel: ObservableObject {
    let manager: TaskDataModel
    
    /// Enthält die aktuell geladenen Aufgaben.
    @Published var task: [PrivateTask] = []
    
    /// Gibt an, ob CoreData erfolgreich initialisiert wurde.
    @Published var isDataLoaded = false
    
    /// Enthält Fehlermeldungen aus dem ViewModel.
    @Published var errorMessage: String?

    init(manager: TaskDataModel) {
        self.manager = manager
        loadData()
    }
    
    
    /// Lädt die CoreData-Datenbank asynchron.
    /// Nach erfolgreichem Laden wird automatisch `fetchTask()` aufgerufen.
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
    
    /// Erstellt eine neue Aufgabe und speichert sie in CoreData.
    /// Anschließend wird die Aufgabenliste aktualisiert und die Daten an das Widget übergeben.
    func createTask(title: String, desc: String, date: Date, category: TaskCategory) {
        let newTask = PrivateTask(context: manager.persistentContainer.viewContext)
        newTask.id = UUID()
        newTask.title = title
        newTask.desc = desc
        newTask.date = date
        newTask.category = category.rawValue
        saveContext()
        fetchTask() 
        TaskStorageHelper.saveTasksToWidget(self.task)
        NotificationManager.shared.scheduleNotification(
            title: title,
            body: "Fällig am \(formatDate(date))",
            at: date
        )
    }

    /// Holt Aufgaben aus CoreData, optional gefiltert nach Suchtext oder "done"-Status.
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
    
    
    /// Löscht eine bestehende Aufgabe aus CoreData.
    /// Aktualisiert anschließend die UI und das Widget.
    func deleteTask(_ task: PrivateTask) {
        let context = manager.persistentContainer.viewContext
        context.delete(task)
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
        
        do {
            try context.save()
            fetchTask()
            
            TaskStorageHelper.saveTasksToWidget(self.task)
           
        } catch {
            print("Fehler beim Löschen der Aufgabe: \(error.localizedDescription)")
        }
    }

    /// Aktualisiert eine bestehende Aufgabe und speichert die Änderungen.
    /// Führt danach ein Neuladen der Liste durch.
    func updateTask(_ task: PrivateTask, title: String, desc: String, isInCalendar: Bool, date: Date) {
        task.title = title
        task.desc = desc
        task.isInCalendar = isInCalendar
        task.date = date
        saveContext()
        fetchTask() // Daten neu laden
    }
    
    /// Speichert Änderungen im aktuellen CoreData-Kontext.
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
    
    
    /// Formatierter Datumstext (medium style, lokalisiert)
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy - HH:mm"
        return formatter.string(from: date)
    }
    
   


}
