//
//  Task.swift
//  ToDoIt
//
//  Created by Caroline Frey on 3/8/23.
//

import Foundation

enum TaskCompletionDate {
    case today
    case nextWeek
}

struct Task {
    var task: String
    var tag: String?
    var date: TaskCompletionDate?
    
    init(task: String, tag: String? = nil, date: TaskCompletionDate? = .today) {
        self.task = task
        self.tag = tag
        self.date = date
    }
}

let dummyTasks: [Task] = [Task(task: "Laundry", tag: "personal", date: .today),
                         Task(task: "Trash", tag: "personal", date: .today),
                         Task(task: "Prep for meeting", tag: "work", date: .today),
                         Task(task: "Build email", tag: "work", date: .today),
                         Task(task: "Groceries", tag: "personal", date: .nextWeek)]
