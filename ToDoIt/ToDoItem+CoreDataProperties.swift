//
//  ToDoItem+CoreDataProperties.swift
//  ToDoIt
//
//  Created by Caroline Frey on 4/11/23.
//
//

import Foundation
import CoreData


extension ToDoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoItem> {
        return NSFetchRequest<ToDoItem>(entityName: "ToDoItem")
    }

    @NSManaged public var tag: String?
    @NSManaged public var task: String?
    @NSManaged public var tags: NSSet?

}

// MARK: Generated accessors for tags
extension ToDoItem {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: Tag)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: Tag)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}

extension ToDoItem : Identifiable {

}
