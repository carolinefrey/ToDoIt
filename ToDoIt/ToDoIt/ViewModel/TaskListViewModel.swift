//
//  TaskListViewModel.swift
//  ToDoIt
//
//  Created by Caroline Frey on 5/29/23.
//

import Foundation
import UIKit

struct TaskListViewModel {
    func batchDeleteSelectedTasks(selectedTasks: [ToDoItem], data: TaskData) {
        for selectedTask in selectedTasks {
            data.toDoItems.completedTasks.removeAll { $0 == selectedTask }
            DataManager.deleteTask(allTasks: data.toDoItems, taskToDelete: selectedTask)
        }
    }
    
    func batchCompleteSelectedTasks(selectedTasks: [ToDoItem], data: TaskData) {
        for selectedTask in selectedTasks {
            data.toDoItems.markTaskComplete(task: selectedTask)
        }
    }
    
    func handleNumRowsInSection(data: TaskData, editMode: EditMode) -> Int {
        if data.filteredToDoItems.count != 0 {
            return data.filteredToDoItems.count
        } else if editMode == .showCompletedTasks {
            return data.toDoItems.completedTasks.count
        } else {
            return data.toDoItems.incompleteTasks.count
        }
    }
    
    func handleCellRowForAt(data: TaskData, cell: TaskTableViewCell, indexPath: IndexPath, editMode: EditMode) -> TaskTableViewCell {
        if data.filteredToDoItems.count != 0 {
            cell.configureTask(task: data.filteredToDoItems[indexPath.row])
        } else if editMode == .showCompletedTasks {
            cell.configureTask(task: data.toDoItems.completedTasks[indexPath.row])
        } else {
            cell.configureTask(task: data.toDoItems.incompleteTasks[indexPath.row])
        }
        cell.backgroundColor = UIColor(named: "background")
        cell.selectionStyle = .none
        cell.accessoryType = .none
        
        return cell
    }
    
    func handleEditingStyle(data: TaskData, indexPath: IndexPath, editingStyle: UITableViewCell.EditingStyle, editMode: EditMode) {
        if editingStyle == .delete {
            if editMode == .showCompletedTasks {
                DataManager.deleteTask(allTasks: data.toDoItems, taskToDelete: data.toDoItems.completedTasks[indexPath.row])
            } else {
                DataManager.deleteTask(allTasks: data.toDoItems, taskToDelete: data.toDoItems.incompleteTasks[indexPath.row])
            }
        }
    }
}
