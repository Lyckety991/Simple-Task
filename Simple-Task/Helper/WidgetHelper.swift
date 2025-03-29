//
//  WidgetHelper.swift
//  Simple-Task
//
//  Created by Patrick Lanham on 28.03.25.
//

import Foundation
import WidgetKit

struct TaskStorageHelper {
    static let appGroupID = "group.dev.patrick.SimpleTask"

    static var sharedContainerURL: URL? {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID)
    }

    static var widgetTaskURL: URL? {
        sharedContainerURL?.appendingPathComponent("nextTask.json")
    }

    // ✅ Neue Methode für mehrere Tasks
    static func saveTasksToWidget(_ tasks: [PrivateTask]) {
        guard let url = widgetTaskURL else { return }

        let items: [TaskEntryItem] = tasks.prefix(5).map {
            TaskEntryItem(
                id: $0.id ?? UUID(),
                title: $0.title ?? "Ohne Titel",
                category: $0.taskCategory.rawValue
            )
        }

        let entry = TaskEntry(date: Date(), tasks: items)

        do {
            let data = try JSONEncoder().encode(entry)
            try data.write(to: url)
            WidgetCenter.shared.reloadAllTimelines()
            print("✅ \(items.count) Aufgaben fürs Widget gespeichert.")
        } catch {
            print("❌ Fehler beim Schreiben: \(error.localizedDescription)")
        }
    }
}
