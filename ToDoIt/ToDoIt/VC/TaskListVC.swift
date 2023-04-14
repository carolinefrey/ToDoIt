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
    
    var toDoItems: [ToDoItem] = []
    
    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()
        contentView = TaskListView()
        view = contentView
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: contentView.todayTitle)
        navigationItem.rightBarButtonItem = contentView.newTaskButton
        
        setContentViewDelegates()
        
        contentView.tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.taskTableViewCellIdentifier)
        
        fetchToDoItems()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        fetchToDoItems()
        contentView.tableView.reloadData()
    }
    
    // MARK: - Functions
    
    private func setContentViewDelegates() {
        contentView.presentTaskViewDelegate = self
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
    }
    
    private func fetchToDoItems() {
        DataManager.fetchTasks { [weak self] tasks in
            if let fetchedTasks = tasks {
                toDoItems = fetchedTasks
            }
            DispatchQueue.main.async { [weak self] in
                self?.contentView.tableView.reloadData()
            }
        }
    }
}

// MARK: - PresentNewTaskViewDelegate

extension TaskListVC: PresentNewTaskViewDelegate {
    func presentNewTaskView() {
        let newTaskVC = NewTaskVC(toDoItems: toDoItems)
        newTaskVC.saveTaskToListDelegate = self
        navigationController?.pushViewController(newTaskVC, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension TaskListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        toDoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.taskTableViewCellIdentifier) as! TaskTableViewCell
        let currentTask = toDoItems[indexPath.row]
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataManager.deleteTask(task: toDoItems[indexPath.row])
            toDoItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Done") { [weak self] (action, view, completionHandler) in
            DataManager.deleteTask(task: (self?.toDoItems[indexPath.row])!)
            self?.toDoItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .right)
            completionHandler(true)
        }
        action.backgroundColor = .systemGreen
        return UISwipeActionsConfiguration(actions: [action])
    }
}

// MARK: - AddNewTaskDelegate

extension TaskListVC: SaveTaskToListDelegate {
    func saveTaskToList() {
        fetchToDoItems()
        self.contentView.tableView.reloadData()
    }
}
