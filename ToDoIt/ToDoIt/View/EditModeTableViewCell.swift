//
//  EditModeTableViewCell.swift
//  ToDoIt
//
//  Created by Caroline Frey on 5/8/23.
//

import UIKit

class EditModeTableViewCell: UITableViewCell {

    static let editModeTableViewCellIdentifier = "EditModeTableViewCell"
        
    // MARK: - UI Properties

    lazy var taskSelectedButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "circle"), for: .normal)
//        button.setImage(UIImage(systemName: "circle.fill"), for: .selected)
        button.addTarget(self, action: #selector(taskSelectedButtonTapped), for: .touchUpInside)
        button.tintColor = .black
        return button
    }()

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
    
    @objc func taskSelectedButtonTapped() {
        taskSelectedButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
    }
    
    func configureTask(task: ToDoItem) {
        taskFieldView.text = task.task
        tagView.text = task.tag
    }
    
    // MARK: - UI Setup
    
    private func configureViews() {
        addSubview(taskSelectedButton)
        addSubview(taskFieldView)
        addSubview(tagView)
        
        NSLayoutConstraint.activate([
            taskSelectedButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            taskSelectedButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            taskFieldView.centerYAnchor.constraint(equalTo: centerYAnchor),
            taskFieldView.leadingAnchor.constraint(equalTo: taskSelectedButton.trailingAnchor, constant: 15),
            taskFieldView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            taskFieldView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            
            tagView.centerYAnchor.constraint(equalTo: centerYAnchor),
            tagView.trailingAnchor.constraint(equalTo: taskFieldView.trailingAnchor, constant: -15)
        ])
    }
}
