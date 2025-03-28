//
//  SimpleTaskWidget.swift
//  SimpleTaskWidget
//
//  Created by Patrick Lanham on 28.03.25.
//

import WidgetKit
import SwiftUI



import SwiftUI
import WidgetKit

struct SimpleTaskWidgetEntryView: View {
    var entry: TaskEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if entry.tasks.isEmpty {
                Text("🎉 Keine Aufgaben")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                ForEach(entry.tasks.prefix(3)) { task in
                    HStack(alignment: .top, spacing: 8) {
                        // Kategorie-Symbol mit Farbe
                        Image(systemName: icon(for: task.category))
                            .foregroundColor(color(for: task.category))
                            .frame(width: 20)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(task.title)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.primary)
                                .lineLimit(1)

                            Text(task.category)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }

                        Spacer()
                    }
                    .padding(8)
                    .background(.thinMaterial)
                    .cornerRadius(8)
                }
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }

    // 🏷 Symbol je Kategorie
    func icon(for category: String) -> String {
        switch category.lowercased() {
        case "privat": return "house"
        case "arbeit": return "briefcase"
        case "wichtig": return "exclamationmark.circle"
        default: return "tag"
        }
    }

    // 🎨 Farbe je Kategorie
    func color(for category: String) -> Color {
        switch category.lowercased() {
        case "privat": return .blue
        case "arbeit": return .green
        case "wichtig": return .red
        default: return .gray
        }
    }
}


struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> TaskEntry {
        TaskEntry(date: Date(), tasks: sampleTasks())
    }

    func getSnapshot(in context: Context, completion: @escaping (TaskEntry) -> ()) {
        let entry = TaskEntry(date: Date(), tasks: sampleTasks())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TaskEntry>) -> Void) {
        let entry = TaskStorageReader.loadTaskForWidget() ??
            TaskEntry(date: Date(), tasks: [])

        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }

    // Beispiel-Daten für Preview und Placeholder
    func sampleTasks() -> [TaskEntryItem] {
        return [
            TaskEntryItem(id: UUID(), title: "Einkaufen", category: "Privat"),
            TaskEntryItem(id: UUID(), title: "Bericht schreiben", category: "Arbeit"),
            TaskEntryItem(id: UUID(), title: "Training", category: "Wichtig")
        ]
    }
}



struct SimpleTaskWidget: Widget {
    let kind: String = "SimpleTaskWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            SimpleTaskWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Nächste Aufgabe")
        .description("Zeigt deine wichtigste Aufgabe.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct SimpleTaskWidget_Previews: PreviewProvider {
    static var previews: some View {
        let previewTasks = [
            TaskEntryItem(id: UUID(), title: "📝 Einkaufsliste", category: "Privat"),
            TaskEntryItem(id: UUID(), title: "📊 Projekt-Review", category: "Arbeit"),
            TaskEntryItem(id: UUID(), title: "🔥 Workout", category: "Wichtig")
        ]

        let entry = TaskEntry(date: Date(), tasks: previewTasks)

        return Group {
            SimpleTaskWidgetEntryView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemSmall))

            SimpleTaskWidgetEntryView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}
