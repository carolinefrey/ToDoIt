//
//  DataManager.swift
//  ToDoIt
//
//  Created by Caroline Frey on 4/3/23.
//

import Foundation
import CoreData
import UIKit

class DataManager {
    static let managedObjectContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    // MARK: - Create
    
    static func saveTask(allTasks: TasksData, task: String, tag: String?, complete: Bool) {
        let toDoItem = ToDoItem(context: managedObjectContext)
        toDoItem.task = task
        toDoItem.tag = tag
        toDoItem.complete = complete

//<<<<<<< HEAD
//        allTasks.incompleteTasks.append(toDoItem)
//        allTasks.allTasks.append(toDoItem)
//=======
        allTasks.toDoItems.append(toDoItem)
//>>>>>>> dbf4d2d45d7d67444b35dbff282602dae3be42d4
        
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
    
    static func deleteTask(allTasks: TasksData, taskToDelete: ToDoItem) {
        managedObjectContext.delete(taskToDelete)
        allTasks.toDoItems.removeAll { $0 == taskToDelete }
        do {
            try managedObjectContext.save()
        }
        catch {
            
        }
    }
}
