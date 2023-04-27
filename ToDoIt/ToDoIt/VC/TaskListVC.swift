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
    
    var toDoItems = Tasks()
    var allTags: Tags
    var filteredToDoItems: [ToDoItem] = []
    var selectedFilter: String = ""
    
    // MARK: - Initializer
    
    init() {
        allTags = Tags(tasks: toDoItems)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()
                    
        contentView = TaskListView(toDoItems: toDoItems.tasks, allTags: allTags.tags)
        view = contentView
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: contentView.todayTitle)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: contentView.navBarButtonStackView)
        
        setContentViewDelegates()
        
        contentView.tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.taskTableViewCellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        contentView.configureFilterMenu()
        contentView.tableView.reloadData()
    }
    
    // MARK: - Functions
    
    private func setContentViewDelegates() {
        contentView.presentTaskViewDelegate = self
        contentView.filterTasksBySelectedTagDelegate = self
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
    }
}

// MARK: - PresentNewTaskViewDelegate

extension TaskListVC: PresentNewTaskViewDelegate {
    func presentNewTaskView() {
        let newTaskVC = NewTaskVC(toDoItems: toDoItems, allTags: allTags)
        newTaskVC.updateTaskListDelegate = self
        navigationController?.pushViewController(newTaskVC, animated: true)
    }
}

// MARK: - FilterTasksBySelectedTagDelegate

extension TaskListVC: FilterTasksBySelectedTagDelegate {
    func filterTasksBySelectedTag(tag: String) {
        //if user taps selected tag again, show all to do items and reset menu
        if selectedFilter == tag {
            filteredToDoItems = []
            contentView.filterButton.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle", withConfiguration: UIImage.SymbolConfiguration(textStyle: .title1)), for: .normal)
        } else {
            selectedFilter = tag
            filteredToDoItems = []
            for task in toDoItems.tasks {
                if task.tag == selectedFilter {
                    filteredToDoItems.append(task)
                }
            }
            contentView.filterButton.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle.fill", withConfiguration: UIImage.SymbolConfiguration(textStyle: .title1)), for: .normal)
        }
        contentView.tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension TaskListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredToDoItems.count != 0 {
            return filteredToDoItems.count
        } else {
            return toDoItems.tasks.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.taskTableViewCellIdentifier) as! TaskTableViewCell
        
        if filteredToDoItems.count != 0 {
            cell.configureTask(task: filteredToDoItems[indexPath.row])
        } else {
            cell.configureTask(task: toDoItems.tasks[indexPath.row])
        }
        
        cell.backgroundColor = UIColor(named: "background")
        let selectedBackgroundView = UIView(frame: .zero)
        selectedBackgroundView.backgroundColor = UIColor(named: "background")
        cell.selectedBackgroundView = selectedBackgroundView
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TaskListVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editTaskVC = EditTaskVC(selectedToDoItem: toDoItems.tasks[indexPath.row], toDoItems: toDoItems, allTags: allTags)
        navigationController?.pushViewController(editTaskVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataManager.deleteTask(allTasks: toDoItems, taskToDelete: toDoItems.tasks[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Done") { [weak self] (action, view, completionHandler) in
            DataManager.deleteTask(allTasks: self!.toDoItems, taskToDelete: (self?.toDoItems.tasks[indexPath.row])!)
            tableView.deleteRows(at: [indexPath], with: .right)
            completionHandler(true)
        }
        action.backgroundColor = .systemGreen
        return UISwipeActionsConfiguration(actions: [action])
    }
}

// MARK: - AddNewTaskDelegate

extension TaskListVC: UpdateTaskListDelegate {
    func updateTaskList() {
        self.contentView.tableView.reloadData()
    }
}
