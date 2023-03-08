//
//  NewTaskView.swift
//  ToDoIt
//
//  Created by Caroline Frey on 3/8/23.
//

import UIKit

protocol PopViewDelegate: AnyObject {
    func popView()
}

class NewTaskView: UIView {
    
    var popViewDelegate: PopViewDelegate?

    // MARK: - UI Properties
    
    let newTaskTitle: UILabel = {
        let newTaskTitle = UILabel()
        newTaskTitle.translatesAutoresizingMaskIntoConstraints = false
        newTaskTitle.font = .boldSystemFont(ofSize: 38)
        newTaskTitle.text = "New Task"
        newTaskTitle.textAlignment = .left
        return newTaskTitle
    }()
    
    lazy var backButton: UIBarButtonItem = {
        let config = UIImage.SymbolConfiguration(textStyle: .title1)
        let icon = UIImage(systemName: "arrowshape.backward", withConfiguration: config)
        let button = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(backButtonTapped))
        button.tintColor = .black
        return button
    }()
    
    lazy var saveTaskButton: UIBarButtonItem = {
        let config = UIImage.SymbolConfiguration(textStyle: .title1)
        let icon = UIImage(systemName: "square.and.arrow.down", withConfiguration: config)
        let button = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(saveTaskButtonTapped))
        button.tintColor = .black
        return button
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
    
    @objc func backButtonTapped() {
        popViewDelegate?.popView()
    }
    
    @objc func saveTaskButtonTapped() {
        //TODO: - Implement save task
    }
    
    private func configureViews() {
        addSubview(newTaskTitle)
        
        NSLayoutConstraint.activate([
            newTaskTitle.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            newTaskTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
        ])
    }
    
    // MARK: - UI Setup
}
