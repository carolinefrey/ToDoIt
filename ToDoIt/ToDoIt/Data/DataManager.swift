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
    
    static func saveTag(tag: String) {
        let newTag = Tag(context: managedObjectContext)
        newTag.tag = tag
        
        do {
            try managedObjectContext.save()
        } catch {
            
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
    
    static func fetchTags(completion: ([Tag]?) -> Void) {
        do {
            let tags = try managedObjectContext.fetch(Tag.fetchRequest())
            completion(tags)
        }
        catch {
            
        }
        
        completion(nil)
    }
    
    static func fetchTag(tag: String, completion: (Tag?) -> Void) {
        let fetchRequest = NSFetchRequest<Tag>(entityName: "Tag")
        fetchRequest.predicate = NSPredicate(format: "Tag == %@", tag)
        
        do {
            let tag = try managedObjectContext.fetch(fetchRequest)
            completion(tag.first)
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
    
    static func updateTag(tag: Tag, updatedTag: String) {
        tag.tag = updatedTag
        
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
    
    static func deleteTag(tag: Tag) {
        managedObjectContext.delete(tag)
        
        do {
            try managedObjectContext.save()
        }
        catch {
            
        }
    }
}
