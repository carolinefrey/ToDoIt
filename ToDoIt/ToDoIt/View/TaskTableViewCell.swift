//
//  TaskTableViewCell.swift
//  ToDoIt
//
//  Created by Caroline Frey on 3/8/23.
//

import UIKit

//TODO: - assign protocol delegate in TaskListVC (?)
protocol MarkTaskAsCompleteDelegate: AnyObject {
    func markTaskAsComplete()
}

class TaskTableViewCell: UITableViewCell {

    static let taskTableViewCellIdentifier = "TaskTableViewCell"
    
    let markTaskAsCompleteDelegate: MarkTaskAsCompleteDelegate?
    
    // MARK: - UI Properties
    
    lazy var checkboxButtonView: UIButton = {
        let checkbox = UIButton()
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 20)
        checkbox.setImage(UIImage(systemName: "square", withConfiguration: config), for: .normal)
        checkbox.addTarget(self, action: #selector(checkboxButtonTapped), for: .touchUpInside)
        checkbox.tintColor = .black
        return checkbox
    }()

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
    
    @objc func checkboxButtonTapped() {
        markTaskAsCompleteDelegate?.markTaskAsComplete()
    }
    
    func configureTask(task: ToDoItem) {
        taskFieldView.text = task.task
        tagView.text = task.tag
    }
    
    // MARK: - UI Setup
    
    private func configureViews() {
        addSubview(checkboxButtonView)
        addSubview(taskFieldView)
        addSubview(tagView)
        
        NSLayoutConstraint.activate([
            checkboxButtonView.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkboxButtonView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            
            taskFieldView.centerYAnchor.constraint(equalTo: centerYAnchor),
            taskFieldView.leadingAnchor.constraint(equalTo: checkboxButtonView.trailingAnchor, constant: 3),
            taskFieldView.trailingAnchor.constraint(equalTo: trailingAnchor),
            taskFieldView.heightAnchor.constraint(equalToConstant: 35),
            
            tagView.topAnchor.constraint(equalTo: taskFieldView.bottomAnchor),
            tagView.leadingAnchor.constraint(equalTo: taskFieldView.leadingAnchor, constant: 6),
        ])
    }

}
