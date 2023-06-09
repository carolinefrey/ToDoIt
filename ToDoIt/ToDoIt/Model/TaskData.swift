//
//  TaskData.swift
//  ToDoIt
//
//  Created by Caroline Frey on 5/29/23.
//

import Foundation

class TasksData {
    var toDoItems: [ToDoItem]
    var allTags: Tags
    
    init() {
        var temp: [ToDoItem] = []
        DataManager.fetchTasks { tasks in
            if let fetchedTasks = tasks {
                temp = fetchedTasks
            }
        }
        self.toDoItems = temp
        allTags = Tags(allToDoItems: toDoItems)
    }
    
    func markToDoItemComplete(task: ToDoItem) {
        for toDoItem in toDoItems {
            if toDoItem == task {
                toDoItem.complete = true
            }
        }
//        task.complete = true
        DataManager.updateTask(toDoItem: task, task: task.task, tag: task.tag, complete: true)
    }
    
    func markToDoItemIncomplete(task: ToDoItem) {
//        task.complete = false
        for toDoItem in toDoItems {
            if toDoItem == task {
                toDoItem.complete = false
            }
        }
        DataManager.updateTask(toDoItem: task, task: task.task, tag: task.tag, complete: false)
    }
    
    func filterToDoItems(by filterType: FilterType) -> [ToDoItem] {
        let toBeFiltered = toDoItems

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
