//
//  ToDoItem+CoreDataProperties.swift
//  ToDoIt
//
//  Created by Caroline Frey on 4/21/23.
//
//

import Foundation
import CoreData


extension ToDoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoItem> {
        return NSFetchRequest<ToDoItem>(entityName: "ToDoItem")
    }

    @NSManaged public var task: String
    @NSManaged public var tag: String?
    @NSManaged public var complete: Bool

}

extension ToDoItem : Identifiable {

}
