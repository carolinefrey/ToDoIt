//
//  NewTaskVC.swift
//  ToDoIt
//
//  Created by Caroline Frey on 3/8/23.
//

import UIKit

protocol AddNewTaskDelegate: AnyObject {
    func addNewTask(task: Task)
}

class NewTaskVC: UIViewController {
    
    private var contentView: NewTaskView!
    
    var newTaskDelegate: AddNewTaskDelegate?

    var tasks: [Task]
    
    // MARK: - Initializer
    
    init(tasks: [Task]) {
        self.tasks = tasks
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    
        contentView = NewTaskView()
        view = contentView
        
        navigationItem.leftBarButtonItem = contentView.backButton
        navigationItem.rightBarButtonItem = contentView.saveTaskButton
        
        contentView.popViewDelegate = self
        contentView.tagsBoxView.presentNewTagViewDelegate = self
        contentView.saveTaskButtonTappedDelegate = self
    }
}

// MARK: - PopViewDelegate

extension NewTaskVC: PopViewDelegate {
    func popView() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - PresentNewTagViewDelegate

extension NewTaskVC: PresentNewTagViewDelegate {
    func presentNewTagView() {
        let addTagAlert = UIAlertController(title: "Add new tag", message: nil, preferredStyle: .alert)
        addTagAlert.addTextField()
        
        let done = UIAlertAction(title: "Done", style: .default) { [unowned addTagAlert] _ in
            let tag = addTagAlert.textFields![0]
            print(tag.text ?? "")
            // TODO: - Display new tag in Tags box
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        addTagAlert.addAction(done)
        addTagAlert.addAction(cancel)
        
        self.present(addTagAlert, animated: true)
    }
}

// MARK: - AddNewTaskDelegate

////this needs to be in TaskListVC?
//extension NewTaskVC: AddNewTaskDelegate {
//    func addNewTask(task: Task) {
//        newTaskDelegate?.addNewTask(task: task)
////        self.tasks.append(task)
//    }
//}

// MARK: - SaveTaskButtonTappedDelegate

extension NewTaskVC: SaveTaskButtonTappedDelegate {
    func saveButtonTapped(task: Task) {
        newTaskDelegate?.addNewTask(task: task)
    }
}
