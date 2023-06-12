//
//  TaskListViewModel.swift
//  ToDoIt
//
//  Created by Caroline Frey on 5/29/23.
//

import Foundation
import UIKit

struct TaskListViewModel {
    func batchDeleteSelectedTasks(data: TasksData, selectedTasks: [ToDoItem]) {
        for task in selectedTasks {
            data.toDoItems.removeAll { $0 == task }
            DataManager.deleteTask(allTasks: data, taskToDelete: task)
        }
    }
    
    func batchCompleteSelectedTasks(data: TasksData, selectedTasks: [ToDoItem]) {
        for selectedTask in selectedTasks {
            data.markToDoItemComplete(task: selectedTask)
        }
    }
    
    func handleNumRowsInSection(data: TasksData, editMode: EditMode, filteredToDoItems: [ToDoItem]) -> Int {
        if filteredToDoItems.count != 0 {
            return filteredToDoItems.count
        } else if editMode == .showCompletedTasks {
            let completedTasks = data.filterToDoItems(by: .complete)
            return completedTasks.count
        } else {
            let incompleteTasks = data.filterToDoItems(by: .incomplete)
            return incompleteTasks.count
        }
    }
    
    func handleCellRowForAt(data: TasksData, cell: TaskTableViewCell, indexPath: IndexPath, editMode: EditMode, filteredToDoItems: [ToDoItem]) -> TaskTableViewCell {
        if filteredToDoItems.count != 0 {
            cell.configureTask(task: filteredToDoItems[indexPath.row])
        } else if editMode == .showCompletedTasks {
            let completedTasks = data.filterToDoItems(by: .complete)
            cell.configureTask(task: completedTasks[indexPath.row])
        } else {
            let incompleteTasks = data.filterToDoItems(by: .incomplete)
            cell.configureTask(task: incompleteTasks[indexPath.row])
        }
        cell.backgroundColor = UIColor(named: "background")
        cell.selectionStyle = .none
        cell.accessoryType = .none
        
        return cell
    }
    
    func handleEditingStyle(data: TasksData, filteredToDoItems: [ToDoItem], indexPath: IndexPath, editingStyle: UITableViewCell.EditingStyle, editMode: EditMode) {
        if editingStyle == .delete {
            if editMode == .showCompletedTasks {
                DataManager.deleteTask(allTasks: data, taskToDelete: data.toDoItems[indexPath.row])
            } else if filteredToDoItems.count != 0 {
                DataManager.deleteTask(allTasks: data, taskToDelete: filteredToDoItems[indexPath.row])
            } else {
                DataManager.deleteTask(allTasks: data, taskToDelete: data.toDoItems[indexPath.row])
            }
        }
    }
}
