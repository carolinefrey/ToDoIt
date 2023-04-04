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
    
    static func saveTask(task: String, tag: String?) {
        let toDoItem = ToDoItem(context: managedObjectContext)
        toDoItem.task = task
        toDoItem.tag = tag
        
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
    
    static func updateTask(toDoItem: ToDoItem, task: String, tag: String) {
        toDoItem.task = task
        toDoItem.tag = tag
        
        do {
            try managedObjectContext.save()
        }
        catch {
            
        }
    }
    
    // MARK: - Delete
    
    static func deleteTask(task: ToDoItem) {
        managedObjectContext.delete(task)
        
        do {
            try managedObjectContext.save()
        }
        catch {
            
        }
    }
}
