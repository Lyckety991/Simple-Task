//
//  NotificationManagerTests_swift.swift
//  NotificationManagerTests.swift
//
//  Created by Patrick Lanham on 29.03.25.
//

import Foundation
import Testing
@testable import Simple_Task

struct NotificationManagerTests {
    
    /// Simulierter Benachrichtigungs-Manager für Tests.
    final class MockNotificationManager {
        var scheduled: [(title: String, date: Date)] = []
        var removedIDs: [String] = []
        
        func schedule(title: String, at date: Date) -> String {
            scheduled.append((title, date))
            return UUID().uuidString
        }
        
        func remove(id: String?) {
            if let id = id {
                removedIDs.append(id)
            }
        }
    }
    
    /// Testet, ob beim Erstellen eines Tasks eine Benachrichtigung geplant wird.
    @Test
    func testCreateTask_schedulesNotification() {
        let mock = MockNotificationManager()
        let viewModel = createTestViewModel(mock: mock)

        let deadline = Date().addingTimeInterval(3600)

        let task = viewModel.createTaskWithMockNotification(
            title: "Test",
            desc: "Reminder",
            date: deadline,
            category: .arbeit,
            reminderOffset: -1800,
            mockManager: mock
        )

        #expect(mock.scheduled.count == 1)
        #expect(mock.scheduled.first?.title == "Test")
        #expect(mock.scheduled.first?.date == deadline.addingTimeInterval(-1800))
    }

    /// Testet, ob beim Löschen eines Tasks die Notification entfernt wird.
    @Test
    func testDeleteTask_removesNotification() {
        let mock = MockNotificationManager()
        let viewModel = createTestViewModel(mock: mock)

        let task = PrivateTask(context: viewModel.manager.viewContext)
        task.id = UUID()
        task.title = "Zum Löschen"
        task.notificationID = "test-id"

        viewModel.task = [task] // manuell setzen
        viewModel.deleteTaskWithMock(task, mockManager: mock)

        #expect(mock.removedIDs.contains("test-id"))
    }

    // MARK: - Testumgebung

    func createTestViewModel(mock: MockNotificationManager) -> TaskViewModel {
        let vm = TaskViewModel(manager: TaskDataModel(inMemory: true))
        vm.task = []
        return vm
    }
}

