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
    
    // MARK: - UI Properties
    
    let todayTitle: UILabel = {
        let todayTitle = UILabel()
        todayTitle.translatesAutoresizingMaskIntoConstraints = false
        todayTitle.font = .boldSystemFont(ofSize: 38)
        todayTitle.text = "Today"
        todayTitle.textAlignment = .left
        return todayTitle
    }()
    
    lazy var newTaskButton: UIBarButtonItem = {
        let config = UIImage.SymbolConfiguration(textStyle: .title1)
        let icon = UIImage(systemName: "plus.circle", withConfiguration: config)
        let button = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(newTaskButtonTapped))
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
    
    @objc func newTaskButtonTapped() {
        presentTaskViewDelegate?.presentNewTaskView()
    }

    // MARK: - UI Setup

    private func configureViews() {

        
        NSLayoutConstraint.activate([
            
        ])
    }
}
