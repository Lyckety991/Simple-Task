//
//  TaskDataModel.swift
//  Simple-Task
//
//  Created by Patrick Lanham on 18.01.25.
//

import Foundation
import CoreData

class TaskDataModel {
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

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
    }
    
    // Preview Provider
    static var preview: TaskDataModel = {
        let provider = TaskDataModel(inMemory: true)
        let viewContext = provider.viewContext

        for index in 1..<10 {
            let taskItem = PrivateTask(context: viewContext)
            taskItem.id = UUID()
            taskItem.title = "Task \(index)"
            taskItem.desc = "Beschreibung für Task \(index)"
            taskItem.date = Date().addingTimeInterval(Double(index) * 3600)
            taskItem.isInCalendar = false
            taskItem.calendarEventID = nil
        }

        do {
            try viewContext.save()
        } catch {
            print("Fehler beim Speichern der Preview-Daten: \(error.localizedDescription)")
        }

        return provider
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
