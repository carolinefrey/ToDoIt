//
//  TaskListContentView.swift
//  ToDoIt
//
//  Created by Caroline Frey on 3/8/23.
//

import UIKit

protocol PresentNewTaskViewDelegate: AnyObject {
    func presentNewTaskView()
}

protocol FilterTasksBySelectedTagDelegate: AnyObject {
    func filterTasksBySelectedTag(tag: String)
}

protocol PresentCompletedTasksViewDelegate: AnyObject {
    func presentCompletedTasksView()
}

class TaskListView: UIView {

    var presentTaskViewDelegate: PresentNewTaskViewDelegate?
    var filterTasksBySelectedTagDelegate: FilterTasksBySelectedTagDelegate?
    var presentCompletedTasksViewDelegate: PresentCompletedTasksViewDelegate?
    var toDoItems: [ToDoItem]
    var allTags: [String]
    var filterMenuItems = UIMenu()
    
    // MARK: - UI Properties
    
    let todayTitle: UILabel = {
        let todayTitle = UILabel()
        todayTitle.translatesAutoresizingMaskIntoConstraints = false
        todayTitle.font = .boldSystemFont(ofSize: 38)
        todayTitle.textColor = UIColor(named: "text")
        todayTitle.text = "Today"
        todayTitle.textAlignment = .left
        return todayTitle
    }()
    
    lazy var filterButton: UIButton = {
        let icon = UIImage(systemName: "line.3.horizontal.decrease.circle", withConfiguration: UIImage.SymbolConfiguration(textStyle: .title1))
        let button = UIButton()
        button.setImage(icon, for: .normal)
        button.menu = filterMenuItems
        button.showsMenuAsPrimaryAction = true
        button.tintColor = UIColor(named: "text")
        return button
    }()
    
    lazy var newTaskButton: UIButton = {
        let icon = UIImage(systemName: "plus.circle", withConfiguration: UIImage.SymbolConfiguration(textStyle: .title1))
        let button = UIButton()
        button.setImage(icon, for: .normal)
        button.addTarget(self, action: #selector(newTaskButtonTapped), for: .touchUpInside)
        button.tintColor = UIColor(named: "text")
        return button
    }()
    
    lazy var navBarButtonStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.distribution = .fill
        stack.spacing = 10
        return stack
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 30
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: "background")
        return tableView
    }()
    
    lazy var showCompletedTasksButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor(named: "text")
        button.setImage(UIImage(systemName: "archivebox.fill", withConfiguration: UIImage.SymbolConfiguration(textStyle: .title1)), for: .normal)
        button.addTarget(self, action: #selector(showCompletedTasksButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initializers
    
    init(toDoItems: [ToDoItem], allTags: [String]) {
        self.toDoItems = toDoItems
        self.allTags = allTags
        
        super.init(frame: .zero)

        backgroundColor = UIColor(named: "background")
        
        configureFilterMenu()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func configureFilterMenu() {
        var filterOptions: [UIAction] = []

        for tag in allTags {
            filterOptions.append(UIAction(title: "\(tag)", handler: { [weak self] selectedTag in
                self?.filterTasksBySelectedTagDelegate?.filterTasksBySelectedTag(tag: selectedTag.title)
            }))
        }
        filterMenuItems = UIMenu(title: "Filter by tag", options: [.displayInline, .singleSelection], children: filterOptions)
    }
    
    @objc func newTaskButtonTapped() {
        presentTaskViewDelegate?.presentNewTaskView()
    }
    
    @objc func showCompletedTasksButtonTapped() {
        presentCompletedTasksViewDelegate?.presentCompletedTasksView()
    }

    // MARK: - UI Setup

    private func configureViews() {
        navBarButtonStackView.addArrangedSubview(filterButton)
        navBarButtonStackView.addArrangedSubview(newTaskButton)
        
        addSubview(tableView)
        addSubview(showCompletedTasksButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9),
            
            showCompletedTasksButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            showCompletedTasksButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
}
