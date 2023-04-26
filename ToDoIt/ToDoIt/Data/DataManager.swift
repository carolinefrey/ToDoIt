//
//  DataManager.swift
//  ToDoIt
//
//  Created by Caroline Frey on 4/3/23.
//

import Foundation
import CoreData
import UIKit

class Tasks {
    var tasks: [ToDoItem]
    
    init() {
        var temp: [ToDoItem] = []
        DataManager.fetchTasks { tasks in
            if let fetchedTasks = tasks {
                temp = fetchedTasks
            }
        }
        self.tasks = temp
    }
}

class Tags {
    var tasks: Tasks
    var tags: [String]
    
    init(tasks: Tasks) {
        var temp: [String] = []
        self.tasks = tasks
        // iterate through tasks and append tags to allTags array, avoiding dupes
        for toDoItem in tasks.tasks {
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
    
    static func saveTask(allTasks: Tasks, task: String, tag: String?) {
        let toDoItem = ToDoItem(context: managedObjectContext)
        toDoItem.task = task
        toDoItem.tag = tag

        allTasks.tasks.append(toDoItem)
        
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
    
    static func updateTask(toDoItem: ToDoItem, task: String?, tag: String?) {
        toDoItem.task = task
        toDoItem.tag = tag
        
        do {
            try managedObjectContext.save()
        }
        catch {
            
        }
    }
    
    // MARK: - Delete
    
    static func deleteTask(allTasks: Tasks, taskToDelete: ToDoItem) {
        managedObjectContext.delete(taskToDelete)
        allTasks.tasks.removeAll { $0 == taskToDelete }
        do {
            try managedObjectContext.save()
        }
        catch {
            
        }
    }
}
