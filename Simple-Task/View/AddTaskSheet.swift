//
//  AddTaskSheet.swift
//  Simple-Task
//
//  Created by Patrick Lanham on 18.01.25.
//

import SwiftUI

struct AddTaskSheet: View {
    @ObservedObject var viewModel: TaskViewModel
    @Binding var isShowingSheet: Bool

    @State private var taskTitle = ""
    @State private var desc = ""
    @State private var selectedDate = Date()
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        NavigationView {
            Form {
                Section("Deine Notiz") {
                    TextField("Deine Aufgabe...", text: $taskTitle)
                        .focused($isTextFieldFocused)
                       
                }
               
                Section("Beschreibung") {
                    TextEditor(text: $desc)
                        .focused($isTextFieldFocused)
                        .frame(height: 150)
                        .cornerRadius(8)
                        
                }
                
                
                    
                Section("Datum & Speichern") {
                    // Datumsauswahl
                    DatePicker("Fälligkeitsdatum", selection: $selectedDate, displayedComponents: .date)
                        .padding(.vertical)

                  
                   
                    
                    Button(action: {
                        if !taskTitle.isEmpty {
                            viewModel.createTask(title: taskTitle, desc: desc, date: selectedDate)
                            taskTitle = ""
                            desc = ""
                            isShowingSheet = false
                            
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
                    
                }
              

            }
            .padding(.horizontal, 2)
            .navigationTitle("Neue Notiz")
            .navigationBarItems(trailing: Button("Abbrechen") {
                isShowingSheet = false
               
            })
            
            
            
            
        }
    }
}

struct AddTaskSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskSheet(
            viewModel: TaskViewModel(manager: TaskDataModel.preview),
            isShowingSheet: .constant(true)
        )
    }
}


extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
