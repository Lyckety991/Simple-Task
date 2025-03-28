import SwiftUI

enum TaskCategory: String, CaseIterable, Identifiable {
    case privat = "Privat"
    case arbeit = "Arbeit"
    case wichtig = "Wichtig"
    case sonstiges = "Sonstiges"

    var id: String { self.rawValue }

    var symbol: String {
        switch self {
        case .privat: return "house"
        case .arbeit: return "briefcase"
        case .wichtig: return "exclamationmark.circle"
        case .sonstiges: return "tag"
        }
    }
    
    var color: Color {
           switch self {
           case .privat: return .blue
           case .arbeit: return .green
           case .wichtig: return .red
           case .sonstiges: return .gray
           }
       }
}

struct ContentView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    @State private var isShowingSheet = false
    @State private var selectedCategoryFilter: TaskCategory? = nil
    @State private var selectedTask: PrivateTask?
    
    @Environment(\.horizontalSizeClass) var sizeClass

    var filteredTasks: [PrivateTask] {
        if let selectedCategory = selectedCategoryFilter {
            return taskViewModel.task.filter { $0.taskCategory == selectedCategory }
        } else {
            return taskViewModel.task
        }
    }

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    Picker("Kategorie", selection: $selectedCategoryFilter) {
                        Text("Alle").tag(TaskCategory?.none)
                        ForEach(TaskCategory.allCases) { category in
                            Label(category.rawValue, systemImage: category.symbol).tag(TaskCategory?.some(category))
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    

                    ScrollView {
                        LazyVGrid(columns: adaptiveGridColumns(for: geometry.size.width), spacing: 16) {
                            ForEach(filteredTasks, id: \.id) { task in
                                TaskCard(task: task, onDelete: { _ in
                                    taskViewModel.deleteTask(task)
                                })
                                .onTapGesture {
                                    selectedTask = task
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.top, 15)
                        .padding(.horizontal, sizeClass == .compact ? 16 : 40)
                    }
                    .navigationTitle("Deine Notizen")

                    HStack {
                        Spacer()
                        FloatingAddButton(isShowingAddTaskSheet: $isShowingSheet)
                        Spacer()
                    }
                    .frame(height: 80)
                    .padding(.bottom, sizeClass == .compact ? 20 : 40)
                }
                .padding(.top, 10)
            }
        }
        .onAppear {
            taskViewModel.loadData()

            // Kleiner Delay, damit Aufgaben geladen sind
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if let nextTask = taskViewModel.task.sorted(by: {
                    ($0.date ?? .distantFuture) < ($1.date ?? .distantFuture)
                }).first {
                    TaskStorageHelper.saveTasksToWidget(taskViewModel.task)

                } else {
                    print("⚠️ Keine Aufgaben gefunden zum Speichern")
                }
            }
        }

        .sheet(isPresented: $isShowingSheet) {
            AddTaskSheet(viewModel: taskViewModel, isShowingSheet: $isShowingSheet)
        }
        .sheet(item: $selectedTask, onDismiss: {
            taskViewModel.fetchTask()
        }) { task in
            DetailView(viewModel: taskViewModel, task: task)
        }
    }

    private func adaptiveGridColumns(for width: CGFloat) -> [GridItem] {
        if width < 600 {
            return [GridItem(.flexible())]
        } else {
            return [GridItem(.flexible()), GridItem(.flexible())]
        }
    }
}

#Preview {
    let dataModel = TaskDataModel.preview
    let viewModel = TaskViewModel(manager: dataModel)

    return ContentView()
        .environmentObject(viewModel)
}
