//
//  TaskListViewModel.swift
//  ToDoIt
//
//  Created by Caroline Frey on 5/29/23.
//

import Foundation
import UIKit

struct TaskListViewModel {
    func batchDeleteSelectedTasks(data: AllTasks, selectedTasks: [ToDoItem]) {
        for task in selectedTasks {
            data.allTasks.removeAll { $0 == task }
            data.completedTasks.removeAll { $0 == task }
            data.incompleteTasks.removeAll { $0 == task }
            DataManager.deleteTask(allTasks: data, taskToDelete: task)
        }
    }
    
    func batchCompleteSelectedTasks(data: AllTasks, selectedTasks: [ToDoItem]) {
        for selectedTask in selectedTasks {
            markTaskComplete(data: data, task: selectedTask)
        }
    }
    
    func handleNumRowsInSection(data: AllTasks, editMode: EditMode, filteredToDoItems: [ToDoItem]) -> Int {
        if filteredToDoItems.count != 0 {
            return filteredToDoItems.count
        } else if editMode == .showCompletedTasks {
            let completedTasks = data.filterTasks(by: .complete)
            return completedTasks.count
        } else {
            let incompleteTasks = data.filterTasks(by: .incomplete)
            return incompleteTasks.count
        }
    }
    
    func handleCellRowForAt(data: AllTasks, cell: TaskTableViewCell, indexPath: IndexPath, editMode: EditMode, filteredToDoItems: [ToDoItem]) -> TaskTableViewCell {
        if filteredToDoItems.count != 0 {
            cell.configureTask(task: filteredToDoItems[indexPath.row])
        } else if editMode == .showCompletedTasks {
            let completedTasks = data.filterTasks(by: .complete)
            cell.configureTask(task: completedTasks[indexPath.row])
        } else {
            let incompleteTasks = data.filterTasks(by: .incomplete)
            cell.configureTask(task: incompleteTasks[indexPath.row])
        }
        cell.backgroundColor = UIColor(named: "background")
        cell.selectionStyle = .none
        cell.accessoryType = .none
        
        return cell
    }
    
    func handleEditingStyle(data: AllTasks, filteredToDoItems: [ToDoItem], indexPath: IndexPath, editingStyle: UITableViewCell.EditingStyle, editMode: EditMode) {
        if editingStyle == .delete {
            if editMode == .showCompletedTasks {
                data.completedTasks.removeAll { $0 == data.completedTasks[indexPath.row] }
                DataManager.deleteTask(allTasks: data, taskToDelete: data.allTasks[indexPath.row])
            } else if filteredToDoItems.count != 0 {
                data.allTasks.removeAll { $0 == filteredToDoItems[indexPath.row] }
                DataManager.deleteTask(allTasks: data, taskToDelete: filteredToDoItems[indexPath.row])
            } else {
                data.completedTasks.removeAll { $0 == data.incompleteTasks[indexPath.row] }
                DataManager.deleteTask(allTasks: data, taskToDelete: data.allTasks[indexPath.row])
            }
        }
    }
    
    func markTaskComplete(data: AllTasks, task: ToDoItem) {
        task.complete = true
        data.incompleteTasks.removeAll { $0 == task }
        data.completedTasks.append(task)
        
        DataManager.updateTask(toDoItem: task, task: task.task, tag: task.tag, complete: true)
    }
    
    func markTaskIncomplete(data: AllTasks, task: ToDoItem) {
        task.complete = false
        data.completedTasks.removeAll { $0 == task }
        data.incompleteTasks.append(task)
        
        DataManager.updateTask(toDoItem: task, task: task.task, tag: task.tag, complete: false)
    }
}
