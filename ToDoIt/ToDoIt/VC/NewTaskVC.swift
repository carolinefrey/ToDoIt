//
//  NewTaskVC.swift
//  ToDoIt
//
//  Created by Caroline Frey on 3/8/23.
//

import UIKit

protocol SaveTaskToListDelegate: AnyObject {
    func saveTaskToList()
}

class NewTaskVC: UIViewController {
    
    private var contentView: NewTaskView!
    
    var saveTaskToListDelegate: SaveTaskToListDelegate?

    var toDoItems: [ToDoItem]
    var allTags: [Tag]
    var selectedTag: Tag
        
    // MARK: - Initializer
    
    init(toDoItems: [ToDoItem]) {
        self.toDoItems = toDoItems
        self.allTags = []
        self.selectedTag = Tag()
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
        
        setContentViewDelegates()
        
        contentView.tagsBoxView.tableView.register(TagsTableViewCell.self, forCellReuseIdentifier: TagsTableViewCell.tagsTableViewCellIdentifier)
        
        fetchTags()
        
    }
    
    // MARK: - Functions
    
    private func fetchTags() {
        DataManager.fetchTags { [weak self] tags in
            if let fetchedTags = tags {
                allTags = fetchedTags
            }
            DispatchQueue.main.async { [weak self] in
                self?.contentView.tagsBoxView.tableView.reloadData()
            }
        }
    }
    
    private func setContentViewDelegates() {
        contentView.popViewDelegate = self
        contentView.saveTaskDelegate = self
        
        contentView.tagsBoxView.presentNewTagViewDelegate = self
        contentView.tagsBoxView.tableView.delegate = self
        contentView.tagsBoxView.tableView.dataSource = self
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
            if let newTag = tag.text {
                DataManager.saveTag(tag: newTag)
            }
            self.fetchTags()
            self.contentView.tagsBoxView.tableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        addTagAlert.addAction(done)
        addTagAlert.addAction(cancel)
        
        self.present(addTagAlert, animated: true)
    }
}

// MARK: - SaveTaskButtonTappedDelegate

extension NewTaskVC: SaveTaskDelegate {
    func saveTask(task: String) {
        DataManager.saveTask(task: task, tag: selectedTag.tag)
        saveTaskToListDelegate?.saveTaskToList()
    }
}

// MARK: - UITableViewDataSource (Tags box)

extension NewTaskVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allTags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contentView.tagsBoxView.tableView.dequeueReusableCell(withIdentifier: TagsTableViewCell.tagsTableViewCellIdentifier) as! TagsTableViewCell
        cell.configureTag(tag: allTags[indexPath.row].tag ?? "") //TODO: - why is this optional?
        return cell
    }
}

// MARK: - UITableViewDelegate (Tags box)

extension NewTaskVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: add tag to task here
        
        //  when a tag is selected from the table, create a (ToDoItem, Tag) tuple
        //  when any "save" function is called, pass this tuple through
        
        // LEFT OFF:
        //  var taskAndTag: (ToDoItem, Tag)
        selectedTag = allTags[indexPath.row]
    }
}
