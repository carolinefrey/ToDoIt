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
    private let viewModel: TaskListViewModel
    
    private var data = TaskData()
    
    var selectedTasks: [ToDoItem] = []

    var editMode: EditMode = .none
    
    var viewTitleNavBar: UIBarButtonItem?
    var navBarButtonStack: UIBarButtonItem?
    var doneButtonNavBar: UIBarButtonItem?
    
    // MARK: - Initializer
    
    init(viewModel: TaskListViewModel) {
        self.viewModel = viewModel
//        allTags = Tags(tasks: toDoItems)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()
                    
        contentView = TaskListView(toDoItems: data.toDoItems.completedTasks, allTags: data.allTags)
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
        contentView.batchEditTasksDelegate = self
        
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
        let newTaskVC = NewTaskVC(toDoItems: data.toDoItems, allTags: data.allTags)
        newTaskVC.updateTaskListDelegate = self
        navigationController?.present(newTaskVC, animated: true)
    }
}

// MARK: - FilterTasksBySelectedTagDelegate

extension TaskListVC: FilterTasksBySelectedTagDelegate {
    func filterTasksBySelectedTag(tag: String) {
        if tag == "All" {
            data.selectedFilter = ""
            data.filteredToDoItems = []
            contentView.filterButton.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle", withConfiguration: UIImage.SymbolConfiguration(textStyle: .title1)), for: .normal)
        } else {
            data.selectedFilter = tag
            data.filteredToDoItems = []
            for task in data.toDoItems.completedTasks {
                if task.tag == data.selectedFilter {
                    data.filteredToDoItems.append(task)
                }
            }
            contentView.filterButton.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle.fill", withConfiguration: UIImage.SymbolConfiguration(textStyle: .title1)), for: .normal)
        }
        contentView.tableView.reloadData()
    }
}

// MARK: - ToggleEditModeDelegate

extension TaskListVC: ToggleEditModeDelegate {
    func toggleVCEditMode(editMode: EditMode) {
        switch editMode {
        case .selectTasks:
            self.editMode = .selectTasks
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: contentView.doneButtonView)
        case .showCompletedTasks:
            self.editMode = .showCompletedTasks
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: contentView.navBarButtonStackView)
            contentView.configureNavBarMenu(editMode: .showCompletedTasks)
        case .none:
            self.editMode = .none
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: contentView.navBarButtonStackView)
            contentView.configureNavBarMenu(editMode: .none)
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

// MARK: - BatchDeleteTasksDelegate {

extension TaskListVC: BatchEditTasksDelegate {
    func batchDeleteSelectedTasks() {
        viewModel.batchDeleteSelectedTasks(selectedTasks: selectedTasks, data: data)
        contentView.tableView.reloadData()
    }
    
    func batchCompleteSelectedTasks() {
        viewModel.batchCompleteSelectedTasks(selectedTasks: selectedTasks, data: data)
        contentView.tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension TaskListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.handleNumRowsInSection(data: data, editMode: editMode)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.taskTableViewCellIdentifier) as! TaskTableViewCell
        return viewModel.handleCellRowForAt(data: data, cell: cell, indexPath: indexPath, editMode: editMode)
    }
}

// MARK: - UITableViewDelegate

extension TaskListVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if editMode != .none {
            tableView.cellForRow(at: indexPath)?.setSelected(true, animated: true)
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            tableView.cellForRow(at: indexPath)?.tintColor = .black
            if editMode == .showCompletedTasks {
                selectedTasks.append(data.toDoItems.completedTasks[indexPath.row])
            } else {
                selectedTasks.append(data.toDoItems.incompleteTasks[indexPath.row])
            }
        } else {
            let editTaskVC = EditTaskVC(selectedToDoItem: data.toDoItems.incompleteTasks[indexPath.row], toDoItems: data.toDoItems, allTags: data.allTags)
            editTaskVC.updateTaskListDelegate = self
            navigationController?.present(editTaskVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = contentView.tableView.cellForRow(at: indexPath) as? TaskTableViewCell {
            cell.accessoryType = .none
            
            if editMode == .showCompletedTasks {
                selectedTasks.removeAll { $0 == data.toDoItems.completedTasks[indexPath.row] }
            } else {
                selectedTasks.removeAll { $0 == data.toDoItems.incompleteTasks[indexPath.row] }
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        viewModel.handleEditingStyle(data: data, indexPath: indexPath, editingStyle: editingStyle, editMode: editMode)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if editMode == .showCompletedTasks {
            // swipe action marks task as incomplete
            let swipeAction = UIContextualAction(style: .normal, title: "Undo") { [weak self] (action, view, completionHandler) in
                self?.data.toDoItems.markTaskIncomplete(task: (self?.data.toDoItems.completedTasks[indexPath.row])!)
                tableView.reloadData()
                completionHandler(true)
            }
            swipeAction.backgroundColor = .lightGray
            return UISwipeActionsConfiguration(actions: [swipeAction])
        } else {
            let swipeAction = UIContextualAction(style: .normal, title: "Done") { [weak self] (action, view, completionHandler) in
                self?.data.toDoItems.markTaskComplete(task: (self?.data.toDoItems.incompleteTasks[indexPath.row])!)
                tableView.reloadData()
                completionHandler(true)
            }
            swipeAction.backgroundColor = .systemGreen
            return UISwipeActionsConfiguration(actions: [swipeAction])
        }
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
