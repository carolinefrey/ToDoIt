//
//  TaskTableViewCell.swift
//  ToDoIt
//
//  Created by Caroline Frey on 3/8/23.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    static let taskTableViewCellIdentifier = "TaskTableViewCell"
        
    // MARK: - UI Properties

    let taskFieldView: UITextView = {
        let field = UITextView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.returnKeyType = .default
        field.font = .systemFont(ofSize: 16)
        field.backgroundColor = UIColor(named: "background")
        return field
    }()
    
    let tagView: UILabel = {
        let tag = UILabel()
        tag.translatesAutoresizingMaskIntoConstraints = false
        tag.font = .systemFont(ofSize: 12)
        tag.textColor = .black
        tag.backgroundColor = UIColor(named: "background")
        return tag
    }()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions

    func configureTask(task: ToDoItem) {
        taskFieldView.text = task.task
        tagView.text = task.tag
    }
    
    // MARK: - UI Setup
    
    private func configureViews() {
        addSubview(taskFieldView)
        addSubview(tagView)
        
        NSLayoutConstraint.activate([
            taskFieldView.centerYAnchor.constraint(equalTo: centerYAnchor),
            taskFieldView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            taskFieldView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            taskFieldView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            
            tagView.centerYAnchor.constraint(equalTo: centerYAnchor),
            tagView.trailingAnchor.constraint(equalTo: taskFieldView.trailingAnchor, constant: -15)
        ])
    }
}
