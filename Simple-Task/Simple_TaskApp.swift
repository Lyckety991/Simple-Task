//
//  Simple_TaskApp.swift
//  Simple-Task
//
//  Created by Patrick Lanham on 18.01.25.
//

import SwiftUI

@main
struct Simple_TaskApp: App {
    @StateObject private var taskViewModel = TaskViewModel(manager: TaskDataModel())

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(taskViewModel)
                .environment(\.managedObjectContext, taskViewModel.manager.persistentContainer.viewContext)
                .onAppear() {
                    NotificationManager.shared.requestAuthorization()

                }
        }
        
    }
}
