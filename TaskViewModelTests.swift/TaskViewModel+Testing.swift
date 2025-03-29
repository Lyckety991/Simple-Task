//
//  TaskViewModel+Testing.swift
//  NotificationManagerTests.swift
//
//  Created by Patrick Lanham on 29.03.25.
//

#if DEBUG
import Foundation
@testable import Simple_Task

extension TaskViewModel {
    func createTaskWithMockNotification(
          title: String,
          desc: String,
          date: Date,
          category: TaskCategory,
          reminderOffset: TimeInterval,
          mockManager: NotificationManagerTests.MockNotificationManager
      ) -> PrivateTask {
          let newTask = PrivateTask(context: manager.viewContext)
          newTask.id = UUID()
          newTask.title = title
          newTask.desc = desc
          newTask.date = date
          newTask.category = category.rawValue

          if reminderOffset != 0 {
              let reminderDate = date.addingTimeInterval(reminderOffset)
              let id = mockManager.schedule(title: title, at: reminderDate)
              newTask.notificationID = id
          }

          task.append(newTask)
          return newTask
      }

      func deleteTaskWithMock(_ task: PrivateTask, mockManager: NotificationManagerTests.MockNotificationManager) {
          mockManager.remove(id: task.notificationID)
          self.task.removeAll { $0.id == task.id }
      }
}
#endif

