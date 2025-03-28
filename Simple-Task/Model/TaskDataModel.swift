//
//  TaskDataModel.swift
//  Simple-Task
//
//  Created by Patrick Lanham on 18.01.25.
//

import Foundation
import CoreData


/// CoreData-Verwaltungsklasse für Aufgaben.
/// Bietet zentrale Zugriffsmöglichkeiten auf den Persistent Container,
/// inklusive Speicherung, Laden und einem Preview-Modus für SwiftUI.
class TaskDataModel {
    
    /// Singleton-Instanz für globalen Zugriff innerhalb der App.
    static let shared = TaskDataModel()
    
    /// Der zentrale CoreData-Persistent Container.
    let persistentContainer: NSPersistentContainer
    
    /// Der Hauptkontext für UI-nahe Operationen.
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    /// Initialisiert den CoreData-Stack mit optionalem In-Memory-Modus (z. B. für Previews).
    /// - Parameter inMemory: Falls `true`, wird der Speicher nicht persistent geschrieben.
    init(inMemory: Bool = false) {
        persistentContainer = NSPersistentContainer(name: "Task")
        
        if inMemory {
            persistentContainer.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        // Persistent Store laden
        persistentContainer.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        /// Speichert Änderungen im Hauptkontext, falls vorhanden.
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    
        /// Lädt CoreData persistent stores asynchron.
        /// Gibt `true` zurück, wenn die Stores erfolgreich geladen wurden.
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
    
    /// Preview-Modus für SwiftUI-Vorschauen mit Dummy-Daten.
    // Preview Provider mit Beispieldaten
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

    /// Leere InMemory-Instanz für Unit-Tests ohne Beispieldaten.
    static var emptyPreview: TaskDataModel = {
        TaskDataModel(inMemory: true)
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
    
    /// InMemory-Instanz für Tests – ohne Beispiel-Daten.
    static let testInstance: TaskDataModel = {
        TaskDataModel(inMemory: true)
    }()

}
