//
//  ContentView.swift
//  Simple-Task
//
//  Created by Patrick Lanham on 18.01.25.
//

import SwiftUI

enum TaskFilter {
    case all, today, past
}



struct ContentView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    @State private var isShowingSheet = false
    @State private var selectedFilter: TaskFilter = .all
    @State private var selectedTask: PrivateTask?
    @State private var isDetailViewPresented = false
    
    @Environment(\.horizontalSizeClass) var sizeClass  // Adaptive Darstellung für iPad/iPhone

    var filteredTasks: [PrivateTask] {
        let today = Calendar.current.startOfDay(for: Date())

        switch selectedFilter {
        case .all:
            return taskViewModel.task
        case .today:
            return taskViewModel.task.filter { Calendar.current.isDate($0.date ?? Date(), inSameDayAs: today) }
        case .past:
            return taskViewModel.task.filter { ($0.date ?? Date()) < today }
        }
    }

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    ScrollView {
                        LazyVGrid(columns: adaptiveGridColumns(for: geometry.size.width), spacing: 16) {
                            ForEach(filteredTasks, id: \.id) { task in
                                TaskCard(task: task, onDelete: {_ in
                                    taskViewModel.deleteTask(task)
                                })
                                .onTapGesture {
                                    selectedTask = task
                                    isDetailViewPresented = true
                                }
                                .frame(maxWidth: .infinity) // Flexible Breite
                            }
                        }
                        .padding(.horizontal, sizeClass == .compact ? 16 : 40) // Mehr Abstand für große Displays
                    }
                    .navigationTitle("Deine Notizen")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Menu {
                                Button("Alle Notizen") { selectedFilter = .all }
                                Button("Heutige Notizen") { selectedFilter = .today }
                                Button("Vergangene Notizen") { selectedFilter = .past }
                            } label: {
                                Image(systemName: "line.3.horizontal.decrease.circle")
                                    .foregroundColor(.blue)
                            }
                        }
                    }

                    // Floating Button unten, angepasst für verschiedene Bildschirmgrößen
                    HStack {
                        Spacer()
                        FloatingAddButton(isShowingAddTaskSheet: $isShowingSheet)
                        Spacer()
                    }
                    .frame(height: 80)
                    .background(Color.clear)
                    .padding(.bottom, sizeClass == .compact ? 20 : 40) // Mehr Abstand auf großen Screens
                }
            }
        }
        .onAppear {
            taskViewModel.loadData()
        }
        .sheet(isPresented: $isShowingSheet) {
            AddTaskSheet(viewModel: taskViewModel, isShowingSheet: $isShowingSheet)
        }
        .sheet(isPresented: $isDetailViewPresented, onDismiss: {
            taskViewModel.fetchTask()
        }) {
            if let selectedTask = selectedTask {
                DetailView(viewModel: taskViewModel, task: Binding(
                    get: { selectedTask },
                    set: { self.selectedTask = $0 }
                ))
                .environmentObject(taskViewModel)
            }
        }
    }

    // Dynamische Spaltenanpassung für verschiedene Bildschirmgrößen
    private func adaptiveGridColumns(for width: CGFloat) -> [GridItem] {
        if width < 600 {
            return [GridItem(.flexible())] // Eine Spalte für iPhone
        } else {
            return [GridItem(.flexible()), GridItem(.flexible())] // Zwei Spalten für größere Screens
        }
    }
}

#Preview {
    let dataModel = TaskDataModel.preview
    let viewModel = TaskViewModel(manager: dataModel)

    return ContentView()
        .environmentObject(viewModel)
}

