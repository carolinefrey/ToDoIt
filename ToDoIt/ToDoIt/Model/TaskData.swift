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

class AllTasks {
    var allTasks: [ToDoItem]
    var completedTasks: [ToDoItem] = []
    var incompleteTasks: [ToDoItem] = []
//=======
//class AllTasks {
//    var completedTasks: [ToDoItem]
//>>>>>>> develop
//    var incompleteTasks: [ToDoItem] = []
    
    init() {
        var temp: [ToDoItem] = []
        DataManager.fetchTasks { tasks in
            if let fetchedTasks = tasks {
                temp = fetchedTasks
            }
        }
//<<<<<<< HEAD
        self.allTasks = temp
        sortTasks(&allTasks)
        // sort tasks into complete/incomplete
//        for task in self.allTasks {
//            if task.complete != true {
//                incompleteTasks.append(task)
//            } else {
//                completedTasks.append(task)
//            }
//        }
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
//            self.completedTasks = temp
            
            //        for task in temp {
            //            if task.complete != true {
            //                incompleteTasks.append(task)
            //                completedTasks.removeAll { $0 == task }
            //>>>>>>> develop
            //            }
            //        }
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

//class Tags {
//    var tasks: AllTasks
//    var tags: [String]
//
//    init(tasks: AllTasks) {
//        var temp: [String] = []
//        self.tasks = tasks
//        // iterate through tasks and append tags to allTags array, avoiding dupes
//<<<<<<< HEAD
//        for toDoItem in tasks.allTasks {
//=======
class Tags {
    var allToDoItems: [ToDoItem]
    var tags: [String]
    
    init(allToDoItems: [ToDoItem]) {
        var temp: [String] = []
        self.allToDoItems = allToDoItems
        // iterate through tasks and append tags to allTags array, avoiding dupes
        for toDoItem in allToDoItems {
//>>>>>>> dbf4d2d45d7d67444b35dbff282602dae3be42d4
//=======
//        for toDoItem in tasks.completedTasks {
//>>>>>>> develop
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
