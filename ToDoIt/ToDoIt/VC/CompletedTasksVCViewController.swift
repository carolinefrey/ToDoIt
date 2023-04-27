//
//  CompletedTasksVCViewController.swift
//  ToDoIt
//
//  Created by Caroline Frey on 4/27/23.
//

import UIKit

class CompletedTasksVCViewController: UIViewController {

    // MARK: - Properties
    
    private var contentView: CompletedTasksView!

    // MARK: UIBarButtonItems

    // MARK: - Initializer

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView = CompletedTasksView()
        view = contentView
    }
    
    // MARK: - Functions

}
