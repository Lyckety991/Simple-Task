//
//  TaskDataModel.swift
//  Simple-Task
//
//  Created by Patrick Lanham on 18.01.25.
//

import Foundation
import CoreData

class TaskDataModel {
    
    /// Singleton-Instanz für den globalen Zugriff
    static let shared = TaskDataModel()
    
    /// Der Core Data Persistent Container.
    let persistentContainer: NSPersistentContainer
    
    /// Der Hauptkontext für die Arbeit mit Core Data im UI-Thread.
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    /// Initialisiert den Core Data Stack.
    /// - Parameter inMemory: Wenn `true`, wird ein flüchtiger Speicher verwendet (z. B. für Previews).
    init(inMemory: Bool = false) {
        persistentContainer = NSPersistentContainer(name: "Task")
        
        if inMemory {
            persistentContainer.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        // Persistent Store nur einmal laden
        persistentContainer.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    
    /// Speichert Änderungen im Hauptkontext, falls vorhanden.
       func saveContext() {
           let context = viewContext
           if context.hasChanges {
               do {
                   try context.save()
               } catch {
                   print("Fehler beim Speichern des Kontexts: \(error.localizedDescription)")
               }
           }
       }
    
    // Preview Provider
    static var preview: TaskDataModel = {
        let manager = TaskDataModel(inMemory: true)
        let context = manager.viewContext

        for index in 1..<10 {
            let taskItem = PrivateTask(context: context)
            taskItem.id = UUID()
            taskItem.title = "Task \(index)"
            taskItem.desc = "Beschreibung für Task \(index)"
            taskItem.date = Date().addingTimeInterval(Double(index) * 3600)
            taskItem.isInCalendar = false
            taskItem.calendarEventID = nil
        }

        do {
            try context.save()
        } catch {
            print("Fehler beim Speichern der Preview-Daten: \(error.localizedDescription)")
        }

        return manager
    }()
    
    func loadCoreData(completion: @escaping (Bool) -> Void) {
        // Prüfen, ob die Stores bereits geladen sind, bevor erneut versucht wird, sie zu laden
        if !persistentContainer.persistentStoreDescriptions.isEmpty {
            completion(true)
            return
        }
        
        persistentContainer.loadPersistentStores { description, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("CoreData loading error \(error.localizedDescription)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }
}
