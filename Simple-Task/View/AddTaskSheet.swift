//
//  AddTaskSheet.swift
//  Simple-Task
//
//  Created by Patrick Lanham on 18.01.25.
//

import SwiftUI

struct AddTaskSheet: View {
    
    /// Sheet-Ansicht zum Erstellen einer neuen Aufgabe.
    /// Enthält Eingabefelder für Titel, Beschreibung, Kategorie und speichert die Aufgabe über das `TaskViewModel`.
    @ObservedObject var viewModel: TaskViewModel
    @Binding var isShowingSheet: Bool

    @State private var taskTitle = ""
    @State private var desc = ""
    @FocusState private var isTextFieldFocused: Bool
    @State private var selectedCategory: TaskCategory = .privat
    @State var selectedDate: Date
    @State private var reminderOffset: TimeInterval = 0

    var body: some View {
        NavigationStack {
            Form {
                // Eingabe für Aufgabentitel
                Section("Deine Notiz") {
                    TextField("Deine Aufgabe...", text: $taskTitle)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                isTextFieldFocused = true
                            }
                        }

                       
                }
                // Eingabe für Beschreibung
                Section("Beschreibung") {
                    TextEditor(text: $desc)
                        .frame(height: 150)
                        .cornerRadius(8)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                isTextFieldFocused = true
                            }
                        }

                        
                }
                
                // Bereich für das Fälligkeitsdatum und der Erinnerung
                Section("Fälligkeit und Erinnerung") {
                    
                    DatePicker("Datum", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                    
                    Picker("Wann erinnern?", selection: $reminderOffset) {
                           Text("Keine Erinnerung").tag(0.0)
                           Text("Zur Fälligkeit").tag(0.1) // Mini-Offset für "gleichzeitig"
                           Text("5 Minuten vorher").tag(-300.0)
                           Text("30 Minuten vorher").tag(-1800.0)
                           Text("1 Stunde vorher").tag(-3600.0)
                           Text("1 Tag vorher").tag(-86400.0)
                       }
                       .pickerStyle(MenuPickerStyle())
                    
                    
                }
                
                

                // Auswahl der Kategorie via Segmented Picker
                Section("Kategorie") {
                    Picker("Kategorie", selection: $selectedCategory) {
                        ForEach(TaskCategory.allCases) { category in
                            Label(category.rawValue, systemImage: category.symbol).tag(category)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                
              
                    // Speichern-Button
                    Button(action: {
                        if !taskTitle.isEmpty {
                            let deadline = selectedDate
                            let reminderDate = selectedDate.addingTimeInterval(reminderOffset)

                            viewModel.createTask(
                                title: taskTitle,
                                desc: desc,
                                date: deadline,
                                category: selectedCategory
                            )

                            // Nur Notification planen, wenn gewünscht
                            if reminderOffset != 0 {
                                NotificationManager.shared.scheduleNotification(
                                    title: "Erinnerung: \(taskTitle)",
                                    body: "Fällig um \(formatDate(deadline))",
                                    at: reminderDate
                                )
                            }

                            hideKeyboard()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                isShowingSheet = false
                                
                            }
                            
                           
                            
                            UINotificationFeedbackGenerator().notificationOccurred(.success)
                        }
                    }) {
                        Text("Speichern")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .disabled(taskTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                    
                
              

            }
            .padding(.horizontal, 2)
            .navigationTitle("Neue Notiz")
            .navigationBarItems(trailing: Button("Abbrechen") {
                isShowingSheet = false
               
            })
            
            
          
            
            
            
        }
        
      
    }
}
// Preview für SwiftUI Canvas
struct AddTaskSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskSheet(
            viewModel: TaskViewModel(manager: TaskDataModel.preview),
            isShowingSheet: .constant(true), selectedDate: Date()
        )
    }
}

// Tastaturausblendung für SwiftUI
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension View {
        /// Formatierter Datumstext (medium style, lokalisiert)
        func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy - HH:mm"
        return formatter.string(from: date)
    }
}

// Erweiterung für Typ-sicheren Zugriff auf Kategorie
extension PrivateTask {
    var taskCategory: TaskCategory {
        get { TaskCategory(rawValue: category ?? "") ?? .sonstiges }
        set { category = newValue.rawValue }
    }
}
