//
//  Tag+CoreDataProperties.swift
//  ToDoIt
//
//  Created by Caroline Frey on 4/11/23.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var tag: String?
    @NSManaged public var toDoItem: NSSet?

}

// MARK: Generated accessors for toDoItem
extension Tag {

    @objc(addToDoItemObject:)
    @NSManaged public func addToToDoItem(_ value: ToDoItem)

    @objc(removeToDoItemObject:)
    @NSManaged public func removeFromToDoItem(_ value: ToDoItem)

    @objc(addToDoItem:)
    @NSManaged public func addToToDoItem(_ values: NSSet)

    @objc(removeToDoItem:)
    @NSManaged public func removeFromToDoItem(_ values: NSSet)

}

extension Tag : Identifiable {

}
