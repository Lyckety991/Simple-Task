//
//  TaskViewModelTests_swift.swift
//  TaskViewModelTests.swift
//
//  Created by Patrick Lanham on 28.03.25.
//
import Testing
import Foundation
@testable import Simple_Task

struct TaskViewModelTests {

    // Hilfsmethode, um pro Test ein sauberes Datenmodell zu erzeugen
    private func createIsolatedViewModel() -> TaskViewModel {
        let manager = TaskDataModel(inMemory: true)
        return TaskViewModel(manager: manager)
    }

    @Test func testCreateTask_addsNewTaskToList() async throws {
        let viewModel = createIsolatedViewModel()
        #expect(viewModel.task.isEmpty)

        viewModel.createTask(
            title: "Testaufgabe",
            desc: "Beschreibung",
            date: Date(),
            category: .arbeit
        )

        #expect(viewModel.task.count == 1)
        #expect(viewModel.task.first?.title == "Testaufgabe")
        #expect(viewModel.task.first?.taskCategory == .arbeit)
    }

    @Test func testDeleteTask_removesTaskFromList() async throws {
        let viewModel = createIsolatedViewModel()

        viewModel.createTask(
            title: "Zum Löschen",
            desc: "Test",
            date: Date(),
            category: .sonstiges
        )

        #expect(viewModel.task.count == 1)

        if let task = viewModel.task.first {
            viewModel.deleteTask(task)
        }

        #expect(viewModel.task.isEmpty)
    }
    
    
    
    @Test func testUpdateTask_updatesValuesCorrectly() async throws {
        let viewModel = createIsolatedViewModel()

        viewModel.createTask(
            title: "Original",
            desc: "Alte Beschreibung",
            date: Date(),
            category: .privat
        )

        #expect(viewModel.task.count == 1)

        guard let task = viewModel.task.first else {
            _ = #expect(Bool(false)) // Aufgabe konnte nicht geladen werden
            return
        }


        let newTitle = "Geändert"
        let newDesc = "Neue Beschreibung"
        let newDate = Date().addingTimeInterval(3600)

        viewModel.updateTask(
            task,
            title: newTitle,
            desc: newDesc,
            isInCalendar: false,
            date: newDate
        )

        viewModel.fetchTask()

        #expect(task.title == newTitle)
        #expect(task.desc == newDesc)
        #expect(Calendar.current.isDate(task.date ?? Date(), equalTo: newDate, toGranularity: .minute))
    }

}
