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
    
    var toDoItems: AllTasks
    var allTags: Tags
    var selectedToDoItem: ToDoItem
    var selectedTag: String
    var selectedTagIndex: IndexPath?
    
    // MARK: - Initializer
    
    init(selectedToDoItem: ToDoItem, toDoItems: AllTasks, allTags: Tags) {
        self.toDoItems = toDoItems
        self.allTags = allTags
        self.selectedToDoItem = selectedToDoItem
        self.selectedTag = selectedToDoItem.tag ?? ""
        
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
                
        setContentViewDelegates()
        
        contentView.tagsBoxView.tableView.register(TagsTableViewCell.self, forCellReuseIdentifier: TagsTableViewCell.tagsTableViewCellIdentifier)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateTaskListDelegate?.updateFilterMenu()
    }
    
    // MARK: - Functions
    
    private func setContentViewDelegates() {
        contentView.saveTaskButtonTappedDelegate = self
        contentView.textFieldDoneButtonTappedDelegate = self
        contentView.tagsBoxView.presentNewTagViewDelegate = self
        contentView.tagsBoxView.tableView.delegate = self
        contentView.tagsBoxView.tableView.dataSource = self
    }
}

// MARK: - SaveTaskButtonTappedDelegate

extension EditTaskVC: SaveTaskButtonTappedDelegate {
    func saveTask() {
        DataManager.updateTask(toDoItem: selectedToDoItem, task: contentView.taskFieldView.text!, tag: selectedTag, complete: false)
        updateTaskListDelegate?.updateTaskList()
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
        cell.tintColor = .black
        
        if allTags.tags[indexPath.row] == selectedToDoItem.tag {
            cell.accessoryType = .checkmark
            cell.tintColor = .black
        } else {
            cell.accessoryType = .none
        }

        return cell
    }
}

// MARK: - UITableViewDelegate (Tags box)

extension EditTaskVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.tintColor = .black
        
        if allTags.tags[indexPath.row] == selectedToDoItem.tag {
            selectedToDoItem.tag = nil
            selectedTag = ""
        } else {
            selectedToDoItem.tag = allTags.tags[indexPath.row]
            selectedTag = allTags.tags[indexPath.row]

        }
        tableView.reloadData()

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
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
