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
