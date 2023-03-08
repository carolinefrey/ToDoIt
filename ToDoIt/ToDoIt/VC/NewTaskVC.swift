//
//  NewTaskVC.swift
//  ToDoIt
//
//  Created by Caroline Frey on 3/8/23.
//

import UIKit

class NewTaskVC: UIViewController {
    
    private var contentView: NewTaskView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        contentView = NewTaskView()
        view = contentView
        
        navigationItem.leftBarButtonItem = contentView.backButton
        navigationItem.rightBarButtonItem = contentView.saveTaskButton
        
        contentView.popViewDelegate = self
    }
    
    // MARK: - Functions
}

// MARK: - PopViewDelegate

extension NewTaskVC: PopViewDelegate {
    func popView() {
        navigationController?.popViewController(animated: true)
    }
}
