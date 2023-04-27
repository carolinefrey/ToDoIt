//
//  EditTaskVC.swift
//  ToDoIt
//
//  Created by Caroline Frey on 4/27/23.
//

import UIKit

class EditTaskVC: UIViewController {
    
    // MARK: - Properties
    
    private var contentView: EditTaskView!
    
    var updateTaskListDelegate: UpdateTaskListDelegate?
    
    var toDoItems: Tasks
    var allTags: Tags
    var selectedToDoItem: ToDoItem
    var selectedTag: String
    
    // MARK: UIBarButtonItems
    
    lazy var saveTaskButton: UIBarButtonItem = {
        let icon = UIImage(systemName: "square.and.arrow.down", withConfiguration: UIImage.SymbolConfiguration(textStyle: .title1))
        let button = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(saveTaskButtonTapped))
        button.tintColor = .black
        button.isEnabled = false //disable button until user enters text
        return button
    }()
    
    lazy var backButton: UIBarButtonItem = {
        let icon = UIImage(systemName: "arrowshape.backward", withConfiguration: UIImage.SymbolConfiguration(textStyle: .title2))
        let button = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(backButtonTapped))
        button.tintColor = .black
        return button
    }()
    
    // MARK: - Initializer
    
    init(selectedToDoItem: ToDoItem, toDoItems: Tasks, allTags: Tags) {
        self.toDoItems = toDoItems
        self.allTags = allTags
        self.selectedToDoItem = selectedToDoItem
        self.selectedTag = ""
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView = EditTaskView(selectedToDoItem: selectedToDoItem)
        view = contentView
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = saveTaskButton
        
        setContentViewDelegates()
        
        contentView.tagsBoxView.tableView.register(TagsTableViewCell.self, forCellReuseIdentifier: TagsTableViewCell.tagsTableViewCellIdentifier)
    }
    
    // MARK: - Functions
    
    private func setContentViewDelegates() {
        contentView.taskFieldView.delegate = self
        contentView.textFieldDoneButtonTappedDelegate = self
        contentView.tagsBoxView.presentNewTagViewDelegate = self
        contentView.tagsBoxView.tableView.delegate = self
        contentView.tagsBoxView.tableView.dataSource = self
    }
    
    @objc func saveTaskButtonTapped() {
        DataManager.updateTask(toDoItem: selectedToDoItem, task: contentView.taskFieldView.text!, tag: selectedTag)
        updateTaskListDelegate?.updateTaskList()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - PresentNewTagViewDelegate

extension EditTaskVC: PresentNewTagViewDelegate {
    func presentNewTagView() {
        let addTagAlert = UIAlertController(title: "Add new tag", message: nil, preferredStyle: .alert)
        addTagAlert.addTextField()
        
        let done = UIAlertAction(title: "Done", style: .default) { [unowned addTagAlert] _ in
            let tag = addTagAlert.textFields![0]
            if let newTag = tag.text {
                if !self.allTags.tags.contains(newTag) {
                    self.allTags.tags.append(newTag)
                }
            }
            self.contentView.tagsBoxView.tableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        addTagAlert.addAction(done)
        addTagAlert.addAction(cancel)
        
        self.present(addTagAlert, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension EditTaskVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if contentView.taskFieldView.text == "" || contentView.taskFieldView.text == selectedToDoItem.task {
            saveTaskButton.isEnabled = false
        } else {
            saveTaskButton.isEnabled = true
        }
    }
}

// MARK: - NotesFieldAddJobViewDelegate

extension EditTaskVC: TextFieldDoneButtonTappedDelegate {
    func textFieldDoneButtonTapped() {
        self.view.endEditing(true)
    }
}

// MARK: - UITableViewDataSource (Tags box)

extension EditTaskVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allTags.tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contentView.tagsBoxView.tableView.dequeueReusableCell(withIdentifier: TagsTableViewCell.tagsTableViewCellIdentifier) as! TagsTableViewCell
        cell.configureTag(tag: allTags.tags[indexPath.row])
        
        if allTags.tags[indexPath.row] == selectedToDoItem.tag {
            cell.accessoryType = .checkmark
            cell.tintColor = .black
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate (Tags box)

extension EditTaskVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = contentView.tagsBoxView.tableView.cellForRow(at: indexPath) as? TagsTableViewCell {
            cell.accessoryType = .checkmark
            cell.tintColor = .black
        }
        selectedTag = allTags.tags[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = contentView.tagsBoxView.tableView.cellForRow(at: indexPath) as? TagsTableViewCell {
            cell.accessoryType = .none
        }
        selectedTag = ""
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // clear tag field of any existing tags that contain the tag being deleted
            for task in toDoItems.tasks {
                if task.tag == allTags.tags[indexPath.row] {
                    task.tag = ""
                }
            }
            allTags.tags.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
