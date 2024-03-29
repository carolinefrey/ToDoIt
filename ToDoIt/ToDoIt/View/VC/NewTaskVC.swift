//
//  NewTaskVC.swift
//  ToDoIt
//
//  Created by Caroline Frey on 3/8/23.
//

import UIKit

protocol UpdateTaskListDelegate: AnyObject {
    func updateTaskList()
    func updateFilterMenu()
}

class NewTaskVC: UIViewController {
    
    // MARK: - Properties
    
    private var contentView: NewTaskView!
    
    var updateTaskListDelegate: UpdateTaskListDelegate?
    
    var toDoItems: AllTasks
    var allTags: Tags
    var selectedTag: String
        
    // MARK: - Initializer
    
    init(toDoItems: AllTasks, allTags: Tags) {
        self.toDoItems = toDoItems
        self.allTags = allTags
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
        
        setContentViewDelegates()
        
        contentView.tagsBoxView.tableView.register(TagsTableViewCell.self, forCellReuseIdentifier: TagsTableViewCell.tagsTableViewCellIdentifier)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateTaskListDelegate?.updateFilterMenu()
    }
    
    // MARK: - Functions
    
    private func setContentViewDelegates() {
        contentView.saveTaskButtonTappedDelegate = self
        contentView.taskFieldView.delegate = self
        contentView.textFieldDoneButtonTappedDelegate = self
        contentView.tagsBoxView.presentNewTagViewDelegate = self
        contentView.tagsBoxView.tableView.delegate = self
        contentView.tagsBoxView.tableView.dataSource = self
    }
}

// MARK: - NavigationButtonTappedDelegate

extension NewTaskVC: SaveTaskButtonTappedDelegate {
    func saveTask() {
        DataManager.saveTask(allTasks: toDoItems, task: contentView.taskFieldView.text!, tag: selectedTag, complete: false)
        updateTaskListDelegate?.updateTaskList()
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

extension NewTaskVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if contentView.taskFieldView.text != "" {
            contentView.saveTaskButton.isEnabled = true
        } else {
            contentView.saveTaskButton.isEnabled = false
        }
    }
}

// MARK: - NotesFieldAddJobViewDelegate

extension NewTaskVC: TextFieldDoneButtonTappedDelegate {
    func textFieldDoneButtonTapped() {
        self.view.endEditing(true)
    }
}

// MARK: - UITableViewDataSource (Tags box)

extension NewTaskVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allTags.tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contentView.tagsBoxView.tableView.dequeueReusableCell(withIdentifier: TagsTableViewCell.tagsTableViewCellIdentifier) as! TagsTableViewCell
        cell.configureTag(tag: allTags.tags[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate (Tags box)

extension NewTaskVC: UITableViewDelegate {
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
            for task in toDoItems.allTasks {
                if task.tag == allTags.tags[indexPath.row] {
                    task.tag = ""
                }
            }
            allTags.tags.remove(at: indexPath.row)
            
            print("DEBUG: allTags, NewTaskVC = \(allTags.tags)")
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
