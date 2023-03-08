//
//  TaskListVC.swift
//  ToDoIt
//
//  Created by Caroline Frey on 3/8/23.
//

import UIKit

class TaskListVC: UIViewController {
    
        
    private var contentView: TaskListView!
    
    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()
        contentView = TaskListView()
        view = contentView
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: contentView.todayTitle)
        navigationItem.rightBarButtonItem = contentView.newTaskButton
        
        contentView.presentTaskViewDelegate = self
    }
    
    // MARK: - Functions
    
}

// MARK: - PresentNewTaskViewDelegate

extension TaskListVC: PresentNewTaskViewDelegate {
    func presentNewTaskView() {
        navigationController?.pushViewController(NewTaskVC(), animated: true)
    }
}

