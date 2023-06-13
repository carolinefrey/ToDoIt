//
//  TaskData.swift
//  ToDoIt
//
//  Created by Caroline Frey on 5/29/23.
//

import Foundation

struct TaskData {
    var toDoItems = AllTasks()
    var allTags: Tags
    var filteredToDoItems: [ToDoItem] = []
    var selectedFilter: String = ""
    
    init() {
        allTags = Tags(tasks: toDoItems)
    }
}

class AllTasks {
    var completedTasks: [ToDoItem]
    var incompleteTasks: [ToDoItem] = []
    
    init() {
        var temp: [ToDoItem] = []
        DataManager.fetchTasks { tasks in
            if let fetchedTasks = tasks {
                temp = fetchedTasks
            }
        }
        self.completedTasks = temp
        
        for task in temp {
            if task.complete != true {
                incompleteTasks.append(task)
                completedTasks.removeAll { $0 == task }
            }
        }
    }
    
    func markTaskComplete(task: ToDoItem) {
        task.complete = true
        incompleteTasks.removeAll { $0 == task }
        completedTasks.append(task)
        
        DataManager.updateTask(toDoItem: task, task: task.task, tag: task.tag, complete: true)
    }
    
    func markTaskIncomplete(task: ToDoItem) {
        task.complete = false
        completedTasks.removeAll { $0 == task }
        incompleteTasks.append(task)
        
        DataManager.updateTask(toDoItem: task, task: task.task, tag: task.tag, complete: false)
    }
}

class Tags {
    var tasks: AllTasks
    var tags: [String]
    
    init(tasks: AllTasks) {
        var temp: [String] = []
        self.tasks = tasks
        // iterate through tasks and append tags to allTags array, avoiding dupes
        for toDoItem in tasks.completedTasks {
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