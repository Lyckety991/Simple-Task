//
//  TaskStorageReader.swift
//  Simple-Task
//
//  Created by Patrick Lanham on 28.03.25.
//

import Foundation

struct TaskStorageReader {
    static let appGroupID = "group.dev.patrick.SimpleTask" // Dein AppGroup-Name

    static var sharedContainerURL: URL? {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID)
    }

    static var widgetTaskURL: URL? {
        sharedContainerURL?.appendingPathComponent("nextTask.json")
    }

    static func loadTaskForWidget() -> TaskEntry? {
        guard let url = widgetTaskURL,
              let data = try? Data(contentsOf: url),
              let entry = try? JSONDecoder().decode(TaskEntry.self, from: data) else {
            return nil
        }
        return entry
    }
}

