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

class TaskListView: UIView {

    var presentTaskViewDelegate: PresentNewTaskViewDelegate?
    var toDoItems: [ToDoItem]
    var allTags: [String]
    var filterMenuItems = UIMenu()
    
    // MARK: - UI Properties
    
    let todayTitle: UILabel = {
        let todayTitle = UILabel()
        todayTitle.translatesAutoresizingMaskIntoConstraints = false
        todayTitle.font = .boldSystemFont(ofSize: 38)
        todayTitle.text = "Today"
        todayTitle.textAlignment = .left
        return todayTitle
    }()
    
    lazy var filterButton: UIBarButtonItem = {
        let config = UIImage.SymbolConfiguration(textStyle: .title1)
        let icon = UIImage(systemName: "line.3.horizontal.decrease.circle", withConfiguration: config)
        let button = UIBarButtonItem(image: icon, menu: filterMenuItems)
        button.tintColor = .black
        return button
    }()
    
    lazy var newTaskButton: UIBarButtonItem = {
        let config = UIImage.SymbolConfiguration(textStyle: .title1)
        let icon = UIImage(systemName: "plus.circle", withConfiguration: config)
        let button = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(newTaskButtonTapped))
        button.tintColor = .black
        return button
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 30
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // MARK: - Initializers
    
    init(toDoItems: [ToDoItem], allTags: [String]) {
        self.toDoItems = toDoItems
        self.allTags = allTags
        
        super.init(frame: .zero)

        backgroundColor = .white
        configureFilterOptions()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func configureFilterOptions() {
        var filterOptions: [UIAction] = []
        
        for tag in allTags {
            filterOptions.append(UIAction(title: "\(tag)", handler: { _ in }))
        }
        
        filterMenuItems = UIMenu(title: "Filter by tag", options: .displayInline, children: filterOptions)
    }
    
    @objc func newTaskButtonTapped() {
        presentTaskViewDelegate?.presentNewTaskView()
    }

    // MARK: - UI Setup

    private func configureViews() {
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
