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
    @AppStorage("isDarkMode") private var isDarkMode = false

   

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(taskViewModel)
                .environment(\.managedObjectContext, taskViewModel.manager.persistentContainer.viewContext)
                .onAppear {
                    NotificationManager.shared.requestAuthorization()
                    // Apply UI mode bei App-Start
                    let style: UIUserInterfaceStyle = isDarkMode ? .dark : .light
                    UIApplication.shared.windows.first?.overrideUserInterfaceStyle = style
                }
        }
    }
}
