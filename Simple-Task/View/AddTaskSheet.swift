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
    @FocusState private var isTextFieldFocused: Bool
    @State private var selectedCategory: TaskCategory = .privat

    var body: some View {
        NavigationStack {
            Form {
                Section("Deine Notiz") {
                    TextField("Deine Aufgabe...", text: $taskTitle)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                isTextFieldFocused = true
                            }
                        }

                       
                }
               
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
                
                Section("Kategorie") {
                    Picker("Kategorie", selection: $selectedCategory) {
                        ForEach(TaskCategory.allCases) { category in
                            Label(category.rawValue, systemImage: category.symbol).tag(category)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                
              
                   
                    Button(action: {
                        if !taskTitle.isEmpty {
                            viewModel.createTask(title: taskTitle, desc: desc, date: Date(), category: selectedCategory)
                            taskTitle = ""
                            desc = ""
                            isShowingSheet = false
                            hideKeyboard()
                            
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

extension PrivateTask {
    var taskCategory: TaskCategory {
        get { TaskCategory(rawValue: category ?? "") ?? .sonstiges }
        set { category = newValue.rawValue }
    }
}
