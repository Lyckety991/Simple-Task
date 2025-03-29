//
//  NotificationManager.swift
//  Simple-Task
//
//  Created by Patrick Lanham on 29.03.25.
//

import Foundation
import UserNotifications

/// Verwaltet lokale Erinnerungen über das System-NotificationCenter
class NotificationManager {
    
    static let shared = NotificationManager()

    private init() {}

    /// Fragt die Erlaubnis vom User an (einmalig beim Start)
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Fehler bei Anfrage: \(error.localizedDescription)")
            } else {
                print(granted ? "Benachrichtigungen erlaubt" : "Benachrichtigungen abgelehnt")
            }
        }
    }

    /// Erstellt eine Erinnerung zu einem bestimmten Zeitpunkt
    func scheduleNotification(title: String, body: String, at date: Date) -> String {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        // Trigger mit Datum
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: date
        ), repeats: false)
        
        let id = UUID().uuidString

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Fehler beim Planen: \(error.localizedDescription)")
            } else {
                print("Erinnerung geplant für \(date)")
            }
        }
        return id
    }
    
    /// Entfernt die Benachrichtigung aus dem System & ID
    func removeNotification(with id: String?) {
        guard let id = id else { return }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        print("Notification entfernt: \(id)")
    }
    
    
}

