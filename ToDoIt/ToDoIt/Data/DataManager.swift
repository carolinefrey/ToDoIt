//
//  DataManager.swift
//  ToDoIt
//
//  Created by Caroline Frey on 4/3/23.
//

import Foundation
import CoreData
import UIKit

enum EditMode {
    case none, selectTasks, showCompletedTasks
}

class AllTasks {
    var allTasks: [ToDoItem]
    var incompleteTasks: [ToDoItem] = []
    
    init() {
        var temp: [ToDoItem] = []
        DataManager.fetchTasks { tasks in
            if let fetchedTasks = tasks {
                temp = fetchedTasks
            }
        }
        self.allTasks = temp
        
        for task in temp {
            if task.complete != true {
                incompleteTasks.append(task)
            }
        }
    }
}

class Tags {
    var tasks: AllTasks
    var tags: [String]
    
    init(tasks: AllTasks) {
        var temp: [String] = []
        self.tasks = tasks
        // iterate through tasks and append tags to allTags array, avoiding dupes
        for toDoItem in tasks.allTasks {
            if let taskTag = toDoItem.tag {
                if taskTag != "" && !temp.contains(taskTag) {
                    temp.append(taskTag)
                }
            }
        }
        self.tags = temp
    }
}

class DataManager {
    static let managedObjectContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    // MARK: - Create
    
    static func saveTask(allTasks: AllTasks, task: String, tag: String?, complete: Bool) {
        let toDoItem = ToDoItem(context: managedObjectContext)
        toDoItem.task = task
        toDoItem.tag = tag
        toDoItem.complete = complete

        allTasks.allTasks.append(toDoItem)
        allTasks.incompleteTasks.append(toDoItem)
        
        do {
            try managedObjectContext.save()
        }
        catch {

        }
    }
    
    // MARK: - Read
    
    static func fetchTasks(completion: ([ToDoItem]?) -> Void) {
        do {
            let tasks = try managedObjectContext.fetch(ToDoItem.fetchRequest())
            completion(tasks)
        }
        catch {
            
        }
        
        completion(nil)
    }
    
    static func fetchTask(task: String, completion: (ToDoItem?) -> Void) {
        let fetchRequest = NSFetchRequest<ToDoItem>(entityName: "ToDoItem")
        fetchRequest.predicate = NSPredicate(format: "ToDoItem == %@", task)
        
        do {
            let task = try managedObjectContext.fetch(fetchRequest)
            completion(task.first)
        }
        catch {
            print("Could not fetch due to error: \(error.localizedDescription)")
        }
        
        completion(nil)
    }
    
    // MARK: - Update
    
    static func updateTask(toDoItem: ToDoItem, task: String, tag: String?, complete: Bool) {
        toDoItem.task = task
        toDoItem.tag = tag
        toDoItem.complete = complete
        
        do {
            try managedObjectContext.save()
        }
        catch {
            
        }
    }
    
    // MARK: - Delete
    
    static func deleteTask(allTasks: AllTasks, taskToDelete: ToDoItem) {
        managedObjectContext.delete(taskToDelete)
        allTasks.allTasks.removeAll { $0 == taskToDelete }
        allTasks.incompleteTasks.removeAll { $0 == taskToDelete }
        do {
            try managedObjectContext.save()
        }
        catch {
            
        }
    }
}
