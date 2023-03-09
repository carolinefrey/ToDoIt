//
//  TaskListVC.swift
//  ToDoIt
//
//  Created by Caroline Frey on 3/8/23.
//

import UIKit

class TaskListVC: UIViewController {
    
    // MARK: - Properties
    
    private var contentView: TaskListView!
    
    var tasks: [Task] = []
    
    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()
        contentView = TaskListView()
        view = contentView
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: contentView.todayTitle)
        navigationItem.rightBarButtonItem = contentView.newTaskButton
        
        contentView.presentTaskViewDelegate = self
        
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        contentView.tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.taskTableViewCellIdentifier)
    }
    
    override func viewDidLoad() {
        contentView.tableView.reloadData()
    }
    
    // MARK: - Functions
    
}

// MARK: - PresentNewTaskViewDelegate

extension TaskListVC: PresentNewTaskViewDelegate {
    func presentNewTaskView() {
        navigationController?.pushViewController(NewTaskVC(tasks: tasks), animated: true)
    }
}

// MARK: - UITableViewDataSource

extension TaskListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.taskTableViewCellIdentifier) as! TaskTableViewCell
        let currentTask = tasks[indexPath.row]
        cell.configureTask(task: currentTask)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TaskListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: - Implement task editing
        //  either directly in cell or present an alert with a textField
    }
}

