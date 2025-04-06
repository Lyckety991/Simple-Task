# 📝 Simple Task – Deine smarte To-Do App

**Simple Task** ist eine moderne und minimalistische To-Do-App für iOS, entwickelt mit **SwiftUI** und **CoreData**. 
Sie unterstützt smarte Features wie lokale **Erinnerungen**, 
ein anpassbares **Homescreen-Widget** und eine intuitive, adaptive Benutzeroberfläche – 
inklusive **Dark Mode** und **mehrsprachiger Lokalisierung** (Deutsch 🇩🇪 / Englisch 🇬🇧).

---

## ✨ Features

- ✅ Aufgaben erstellen mit Titel, Beschreibung, Fälligkeitsdatum & Kategorie  
- 🔔 Lokale Erinnerungen mit flexiblen Zeitoptionen (z. B. „5 Minuten vorher“)  
- 🧹 **Swipe to Delete** – modernes Task-Handling  
- 🧠 Intelligente **Kategorie-Filterung** (Wichtig, Arbeit, Privat usw.)  
- 🎨 Unterstützt **Light / Dark Mode**  
- 🌍 Lokalisierung für **Deutsch & Englisch**  
- 📱 Homescreen-**Widget** zeigt anstehende Aufgaben & Prioritäten  
- 🧩 Integration mit App Groups für Widget-Kommunikation  
- ⚙️ Einstellungsseite (Dark Mode, Benachrichtigungen aktivieren, Feedback senden)

---


## 🔧 Technologien

- `SwiftUI`
- `CoreData`
- `UserNotifications`
- `WidgetKit`
- `AppStorage` & `App Groups`
- `MVVM` Architektur
- Lokalisierung via `.strings` Dateien

---

## 🧪 Tests

Das Projekt enthält Unit Tests für:

- ✅ Task-Erstellung
- ✅ Task-Löschung
- ✅ Erinnerungsplanung & -entfernung


---

## 🚀 Getting Started

1. Projekt in **Xcode 15+** öffnen  
2. Ziel: `Simple-Task` auswählen  
3. App starten (`Cmd + R`)  
4. Bei Bedarf: Lokalisierung & Widgets in Einstellungen aktivieren

---

## 📦 App Group Setup (für Widget)

Stelle sicher, dass in Xcode unter:

> `Signing & Capabilities > App Groups`

der Eintrag `group.dev.patrick.SimpleTask` **aktiviert ist** – sowohl für App als auch Widget-Target.

---

## 🛠 To-Do / Roadmap

- [ ] iCloud-Sync (CoreData + CloudKit)
- [ ] Drag & Drop Sortierung
- [ ] Mehr Kategorien (mit Icons)
- [ ] Apple Watch App (✨ Wunschfunktion)

---

## 📄 License

MIT License. Feel free to fork & improve.  
Made with ❤️ by [Patrick Lanham](https://github.com/your-profile)



