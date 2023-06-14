//
//  TaskData.swift
//  ToDoIt
//
//  Created by Caroline Frey on 5/29/23.
//

import Foundation

class AllTasks {
    var allTasks: [ToDoItem]
    var completedTasks: [ToDoItem] = []
    var incompleteTasks: [ToDoItem] = []
    var allTags: Tags

    init() {
        var temp: [ToDoItem] = []
        DataManager.fetchTasks { tasks in
            if let fetchedTasks = tasks {
                temp = fetchedTasks
            }
        }

        self.allTasks = temp
        allTags = Tags(allToDoItems: allTasks)

        sortTasks(&allTasks)
    }
    
    func fetchTasks() -> [ToDoItem] {
        var temp: [ToDoItem] = []
        DataManager.fetchTasks { tasks in
            if let fetchedTasks = tasks {
                temp = fetchedTasks
            }
        }
        return temp
    }
    
    func sortTasks(_ allTasks: inout [ToDoItem]) {
        for task in allTasks {
            if task.complete == true {
                completedTasks.append(task)
            } else {
                incompleteTasks.append(task)
            }
        }
    }
    
    func filterTasks(by filterType: FilterType) -> [ToDoItem] {
        let toBeFiltered = allTasks

        switch filterType {
        case .incomplete:
            return toBeFiltered.filter { $0.complete == false }
        case .complete:
            return toBeFiltered.filter { $0.complete == true }
        case .tag(let tag):
            return toBeFiltered.filter { $0.tag == tag }
        }
    }
}

class Tags {
    var allToDoItems: [ToDoItem]
    var tags: [String]
    
    init(allToDoItems: [ToDoItem]) {
        var temp: [String] = []
        self.allToDoItems = allToDoItems
        // iterate through tasks and append tags to allTags array, avoiding dupes
        for toDoItem in allToDoItems {
            if let taskTag = toDoItem.tag {
                if taskTag != "" && !temp.contains(taskTag) {
                    temp.append(taskTag)
                }
            }
        }
        self.tags = temp
    }
}

enum EditMode {
    case none, selectTasks, showCompletedTasks
}

enum FilterType {
    case incomplete, complete, tag(String)
}
