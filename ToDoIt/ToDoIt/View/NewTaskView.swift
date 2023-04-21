//
//  NewTaskView.swift
//  ToDoIt
//
//  Created by Caroline Frey on 3/8/23.
//

import UIKit

//protocol PopViewDelegate: AnyObject {
//    func popView()
//}

//protocol SaveTaskDelegate: AnyObject {
//    func saveTask(task: String)
//}

class NewTaskView: UIView {
    
//    var popViewDelegate: PopViewDelegate?
//    var saveTaskDelegate: SaveTaskDelegate?

    // MARK: - UI Properties
    
    let newTaskViewTitle: UILabel = {
        let newTaskTitle = UILabel()
        newTaskTitle.translatesAutoresizingMaskIntoConstraints = false
        newTaskTitle.font = .boldSystemFont(ofSize: 38)
        newTaskTitle.text = "New Task"
        newTaskTitle.textAlignment = .left
        return newTaskTitle
    }()
    
//    lazy var backButton: UIBarButtonItem = {
//        let config = UIImage.SymbolConfiguration(textStyle: .title2)
//        let icon = UIImage(systemName: "arrowshape.backward", withConfiguration: config)
//        let button = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(backButtonTapped))
//        button.tintColor = .black
//        return button
//    }()
    
//    lazy var saveTaskButton: UIBarButtonItem = {
//        let config = UIImage.SymbolConfiguration(textStyle: .title1)
//        let icon = UIImage(systemName: "square.and.arrow.down", withConfiguration: config)
//        let button = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(saveTaskButtonTapped))
//        button.tintColor = .black
//        return button
//    }()
    
    let taskFieldView: UITextView = {
        let field = UITextView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.returnKeyType = .default
        field.font = .systemFont(ofSize: 16)
        return field
    }()
    
    let tagsBoxView: TagsBoxView = {
        let box = TagsBoxView()
        box.translatesAutoresizingMaskIntoConstraints = false
        return box
    }()

    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
//    @objc func backButtonTapped() {
//        popViewDelegate?.popView()
//    }
    
//    @objc func saveTaskButtonTapped() {        
//        saveTaskDelegate?.saveTask(task: taskFieldView.text)
//        popViewDelegate?.popView()
//    }
    
    // MARK: - UI Setup
    
    private func configureViews() {
        addSubview(newTaskViewTitle)
        addSubview(taskFieldView)
        addSubview(tagsBoxView)
        
        NSLayoutConstraint.activate([
            newTaskViewTitle.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            newTaskViewTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            taskFieldView.topAnchor.constraint(equalTo: newTaskViewTitle.bottomAnchor, constant: 20),
            taskFieldView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            taskFieldView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            taskFieldView.heightAnchor.constraint(equalToConstant: 150),
            
            tagsBoxView.topAnchor.constraint(equalTo: taskFieldView.bottomAnchor, constant: 50),
            tagsBoxView.centerXAnchor.constraint(equalTo: centerXAnchor),
            tagsBoxView.heightAnchor.constraint(equalToConstant: 150),
            tagsBoxView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.90),
        ])
    }
}
