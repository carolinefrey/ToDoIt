//
//  NewTaskVC.swift
//  ToDoIt
//
//  Created by Caroline Frey on 3/8/23.
//

import UIKit

protocol UpdateTaskListDelegate: AnyObject {
    func updateTaskList()
}

class NewTaskVC: UIViewController {
    
    // MARK: - Properties
    
    private var contentView: NewTaskView!
    
    var updateTaskListDelegate: UpdateTaskListDelegate?

    var toDoItems: [ToDoItem]
    var allTags: [String]
    var selectedTag: String
    
    // MARK: UIBarButtonItems
    
    lazy var saveTaskButton: UIBarButtonItem = {
        let config = UIImage.SymbolConfiguration(textStyle: .title1)
        let icon = UIImage(systemName: "square.and.arrow.down", withConfiguration: config)
        let button = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(saveTaskButtonTapped))
        button.tintColor = .black
        return button
    }()
    
    lazy var backButton: UIBarButtonItem = {
        let config = UIImage.SymbolConfiguration(textStyle: .title2)
        let icon = UIImage(systemName: "arrowshape.backward", withConfiguration: config)
        let button = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(backButtonTapped))
        button.tintColor = .black
        return button
    }()
        
    // MARK: - Initializer
    
    init(toDoItems: [ToDoItem]) {
        self.toDoItems = toDoItems
        self.allTags = []
        self.selectedTag = ""
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
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = saveTaskButton
        
        setContentViewDelegates()
        
        contentView.tagsBoxView.tableView.register(TagsTableViewCell.self, forCellReuseIdentifier: TagsTableViewCell.tagsTableViewCellIdentifier)
        
//        fetchTags()
    }
    
    // MARK: - Functions
    
//    private func fetchTags() {
//        DataManager.fetchTags { [weak self] tags in
//            if let fetchedTags = tags {
//                allTags = fetchedTags
//            }
//            DispatchQueue.main.async { [weak self] in
//                self?.contentView.tagsBoxView.tableView.reloadData()
//            }
//        }
//    }
    
    private func setContentViewDelegates() {
//        contentView.popViewDelegate = self
//        contentView.saveTaskDelegate = self
        
        contentView.tagsBoxView.presentNewTagViewDelegate = self
        contentView.tagsBoxView.tableView.delegate = self
        contentView.tagsBoxView.tableView.dataSource = self
    }
    
    @objc func saveTaskButtonTapped() {
//        saveTaskDelegate?.saveTask(task: taskFieldView.text)
        DataManager.saveTask(task: contentView.taskFieldView.text, tag: selectedTag)
        updateTaskListDelegate?.updateTaskList()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - PopViewDelegate

//extension NewTaskVC: PopViewDelegate {
//    func popView() {
//        navigationController?.popViewController(animated: true)
//    }
//}

// MARK: - PresentNewTagViewDelegate

extension NewTaskVC: PresentNewTagViewDelegate {
    func presentNewTagView() {
        let addTagAlert = UIAlertController(title: "Add new tag", message: nil, preferredStyle: .alert)
        addTagAlert.addTextField()
        
        let done = UIAlertAction(title: "Done", style: .default) { [unowned addTagAlert] _ in
            let tag = addTagAlert.textFields![0]
            if let newTag = tag.text {
                self.allTags.append(newTag)
            }
//            self.fetchTags()
            self.contentView.tagsBoxView.tableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        addTagAlert.addAction(done)
        addTagAlert.addAction(cancel)
        
        self.present(addTagAlert, animated: true)
    }
}

// MARK: - SaveTaskButtonTappedDelegate

//extension NewTaskVC: SaveTaskDelegate {
//    func saveTask(task: String) {
//        DataManager.saveTask(task: task, tag: selectedTag.tag)
//        updateTaskListDelegate?.updateTaskList()
//    }
//}

// MARK: - UITableViewDataSource (Tags box)

extension NewTaskVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allTags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contentView.tagsBoxView.tableView.dequeueReusableCell(withIdentifier: TagsTableViewCell.tagsTableViewCellIdentifier) as! TagsTableViewCell
        cell.configureTag(tag: allTags[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate (Tags box)

extension NewTaskVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTag = allTags[indexPath.row]
    }
}
