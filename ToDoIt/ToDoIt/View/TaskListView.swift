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

class TaskListView: UIView {

    var presentTaskViewDelegate: PresentNewTaskViewDelegate?
    var filterTasksBySelectedTagDelegate: FilterTasksBySelectedTagDelegate?
    var toDoItems: [ToDoItem]
    var allTags: Tags
    var filterMenu = UIMenu()
    var navBarMenu = UIMenu()
    
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
        button.showsMenuAsPrimaryAction = true
        button.tintColor = UIColor(named: "text")
        return button
    }()
    
    lazy var navBarMenuButton: UIButton = {
        let icon = UIImage(systemName: "ellipsis.circle", withConfiguration: UIImage.SymbolConfiguration(textStyle: .title1))
        let button = UIButton()
        button.setImage(icon, for: .normal)
        button.showsMenuAsPrimaryAction = true
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
    
    lazy var newTaskButton: UIButton = {
        let icon = UIImage(systemName: "plus.circle", withConfiguration: UIImage.SymbolConfiguration(textStyle: .title1))
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(icon, for: .normal)
        button.addTarget(self, action: #selector(newTaskButtonTapped), for: .touchUpInside)
        button.tintColor = UIColor(named: "text")
        return button
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
    
    // MARK: - Initializers
    
    init(toDoItems: [ToDoItem], allTags: Tags) {
        self.toDoItems = toDoItems
        self.allTags = allTags
        
        super.init(frame: .zero)

        backgroundColor = UIColor(named: "background")
        
        configureFilterMenu()
        configureNavBarMenu()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func configureFilterMenu() {
        var filterOptions: [UIAction] = []
        
        filterOptions.append(UIAction(title: "All", state: .on, handler: { [weak self] selectedTag in
            self?.filterTasksBySelectedTagDelegate?.filterTasksBySelectedTag(tag: selectedTag.title)
        }))

        for tag in allTags.tags {
            filterOptions.append(UIAction(title: "\(tag)", handler: { [weak self] selectedTag in
                self?.filterTasksBySelectedTagDelegate?.filterTasksBySelectedTag(tag: selectedTag.title)
            }))
        }
        filterMenu = UIMenu(title: "Filter by tag", options: [.displayInline, .singleSelection], children: filterOptions)
        filterButton.menu = filterMenu
    }
    
    func configureNavBarMenu() {
        var navBarMenuItems: [UIAction] = []
        
        navBarMenuItems.append(UIAction(title: "Select Tasks", image: UIImage(systemName: "checkmark.circle"), handler: { selectTasks in
            // TODO: - implement
        }))
        
        navBarMenuItems.append(UIAction(title: "Show Completed", image: UIImage(systemName: "eye"), handler: { showCompletedTasks in
            // TODO: - implement
            
            //  when selected, switch menu item to be "Hide Completed" to turn off
        }))

        navBarMenu = UIMenu(title: "", options: [.displayInline, .singleSelection], children: navBarMenuItems)
        navBarMenuButton.menu = navBarMenu
    }
    
    @objc func newTaskButtonTapped() {
        presentTaskViewDelegate?.presentNewTaskView()
    }

    // MARK: - UI Setup

    private func configureViews() {
        navBarButtonStackView.addArrangedSubview(filterButton)
        navBarButtonStackView.addArrangedSubview(navBarMenuButton)
        
        addSubview(tableView)
        addSubview(newTaskButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9),
            
            newTaskButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            newTaskButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
        ])
    }
}
