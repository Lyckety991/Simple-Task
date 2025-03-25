//
//  CalendarManager.swift
//  Simple-Task
//
//  Created by Patrick Lanham on 08.02.25.
//

import EventKit

class CalendarManager {
    private let eventStore = EKEventStore()

    // Funktion, um Berechtigungen anzufordern
    func requestCalendarAccess(completion: @escaping (Bool, Error?) -> Void) {
        if #available(iOS 17.0, *) {
            eventStore.requestFullAccessToEvents(completion: completion)
        } else {
            eventStore.requestAccess(to: .event, completion: completion)
        }
    }

    // Funktion, um ein Event zum Kalender hinzuzufügen
    func addEvent(title: String, startDate: Date, endDate: Date, notes: String?, completion: @escaping (String?, Error?) -> Void) {
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.notes = notes
        event.calendar = eventStore.defaultCalendarForNewEvents

        do {
            try eventStore.save(event, span: .thisEvent)
            completion(event.eventIdentifier, nil) // Rückgabe der Event-ID
        } catch {
            completion(nil, error) // Rückgabe des Fehlers
        }
    }

    // Funktion, um ein Event aus dem Kalender zu entfernen
    func removeEvent(eventID: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let event = eventStore.event(withIdentifier: eventID) else {
            completion(false, nil) // Event nicht gefunden
            return
        }

        do {
            try eventStore.remove(event, span: .thisEvent)
            completion(true, nil) // Erfolgreich entfernt
        } catch {
            completion(false, error) // Rückgabe des Fehlers
        }
    }
}
