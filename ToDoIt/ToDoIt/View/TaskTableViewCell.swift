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
        return field
    }()
    
    let tagView: UILabel = {
        let tag = UILabel()
        tag.translatesAutoresizingMaskIntoConstraints = false
        tag.font = .systemFont(ofSize: 12)
        tag.textColor = .gray
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
    
    func configureTask(task: Task) {
        taskFieldView.text = task.task
        tagView.text = task.tag
    }
    
    // MARK: - UI Setup
    
    private func configureViews() {
        addSubview(taskFieldView)
        addSubview(tagView)
        
        NSLayoutConstraint.activate([
            taskFieldView.topAnchor.constraint(equalTo: topAnchor),
            taskFieldView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            taskFieldView.trailingAnchor.constraint(equalTo: trailingAnchor),
            taskFieldView.heightAnchor.constraint(equalToConstant: 35),
            
            tagView.topAnchor.constraint(equalTo: taskFieldView.bottomAnchor),
            tagView.leadingAnchor.constraint(equalTo: taskFieldView.leadingAnchor, constant: 6),
        ])
    }

}
