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
    var selectedTasks: [ToDoItem] = []
    var editMode: Bool = false
    
    var viewTitleNavBar: UIBarButtonItem?
    var navBarButtonStack: UIBarButtonItem?
    var doneButtonNavBar: UIBarButtonItem?
    
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
                    
        contentView = TaskListView(toDoItems: toDoItems.tasks, allTags: allTags)
        view = contentView
        
        configureNavigationController()
        setContentViewDelegates()
        registerTableViewCells()
    }
    
    override func viewDidLoad() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: contentView.viewTitle)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: contentView.navBarButtonStackView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        contentView.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        contentView.configureFilterMenu()
    }
    
    // MARK: - Functions
    
    private func setContentViewDelegates() {
        contentView.presentTaskViewDelegate = self
        contentView.filterTasksBySelectedTagDelegate = self
        contentView.toggleEditModeDelegate = self
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
    }
    
    private func configureNavigationController() {
        navigationController?.navigationBar.isTranslucent = true
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithOpaqueBackground()
        standardAppearance.backgroundColor = UIColor(named: "background")
        navigationController?.navigationBar.standardAppearance = standardAppearance
    }
    
    private func registerTableViewCells() {
        contentView.tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.taskTableViewCellIdentifier)
        contentView.tableView.register(EditModeTableViewCell.self, forCellReuseIdentifier: EditModeTableViewCell.editModeTableViewCellIdentifier)
        contentView.tableView.allowsMultipleSelection = true
    }
}

// MARK: - PresentNewTaskViewDelegate

extension TaskListVC: PresentNewTaskViewDelegate {
    func presentNewTaskView() {
        let newTaskVC = NewTaskVC(toDoItems: toDoItems, allTags: allTags)
        newTaskVC.updateTaskListDelegate = self
        navigationController?.present(newTaskVC, animated: true)
    }
}

// MARK: - FilterTasksBySelectedTagDelegate

extension TaskListVC: FilterTasksBySelectedTagDelegate {
    func filterTasksBySelectedTag(tag: String) {
        if tag == "All" {
            selectedFilter = ""
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

// MARK: - ToggleEditModeDelegate

extension TaskListVC: ToggleEditModeDelegate {
    func toggleVCEditMode(editMode: Bool) {
        if editMode { // turn on
            self.editMode = true
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: contentView.doneButtonView)
        } else { // turn off
            self.editMode = false
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: contentView.navBarButtonStackView)
            selectedTasks.removeAll()
            contentView.tableView.removeRowSelections()
        }
        contentView.tableView.reloadData()
    }
}

// MARK: - AddNewTaskDelegate

extension TaskListVC: UpdateTaskListDelegate {
    func updateTaskList() {
        self.contentView.tableView.reloadData()
        navigationController?.dismiss(animated: true)
    }
    
    func updateFilterMenu() {
        contentView.configureFilterMenu()
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
        cell.selectionStyle = .none
        cell.accessoryType = .none
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TaskListVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if editMode {
            tableView.cellForRow(at: indexPath)?.setSelected(true, animated: true)
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            tableView.cellForRow(at: indexPath)?.tintColor = .black
            selectedTasks.append(toDoItems.tasks[indexPath.row])
        } else {
            let editTaskVC = EditTaskVC(selectedToDoItem: toDoItems.tasks[indexPath.row], toDoItems: toDoItems, allTags: allTags)
            editTaskVC.updateTaskListDelegate = self
            navigationController?.present(editTaskVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = contentView.tableView.cellForRow(at: indexPath) as? TaskTableViewCell {
            cell.accessoryType = .none
            selectedTasks.remove(at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataManager.deleteTask(allTasks: toDoItems, taskToDelete: toDoItems.tasks[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let completeTask = UIContextualAction(style: .normal, title: "Done") { [weak self] (action, view, completionHandler) in
            DataManager.deleteTask(allTasks: self!.toDoItems, taskToDelete: (self?.toDoItems.tasks[indexPath.row])!)
            tableView.deleteRows(at: [indexPath], with: .right)
            completionHandler(true)
        }
        completeTask.backgroundColor = .systemGreen
        return UISwipeActionsConfiguration(actions: [completeTask])
    }
}

// MARK: - Remove Row Selections

extension UITableView {
    func removeRowSelections() {
        self.indexPathsForSelectedRows?.forEach {
            self.deselectRow(at: $0, animated: true)
        }
    }
}
