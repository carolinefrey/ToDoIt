//
//  EditTaskView.swift
//  ToDoIt
//
//  Created by Caroline Frey on 4/27/23.
//

import UIKit

class EditTaskView: UIView {

    weak var textFieldDoneButtonTappedDelegate: TextFieldDoneButtonTappedDelegate?
    
    var selectedToDoItem: ToDoItem

    // MARK: - UI Properties
        
    let viewTitleLabel: UILabel = {
        let viewTitle = UILabel()
        viewTitle.translatesAutoresizingMaskIntoConstraints = false
        viewTitle.font = .boldSystemFont(ofSize: 38)
        viewTitle.text = "Edit Task"
        viewTitle.textAlignment = .left
        return viewTitle
    }()
    
    let taskFieldView: UITextView = {
        let field = UITextView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.returnKeyType = .default
        field.font = .systemFont(ofSize: 16)
        return field
    }()
    
    let tagsBoxView: TagsBoxView = {
        let box = TagsBoxView()
        box.translatesAutoresizingMaskIntoConstraints = false
        return box
    }()
    
    let keyboardToolbar: UIToolbar = {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        keyboardToolbar.setItems([flexible, doneBarButton], animated: false)
        return keyboardToolbar
    }()

    // MARK: - Initializers
    
    init(selectedToDoItem: ToDoItem) {
        self.selectedToDoItem = selectedToDoItem
        super.init(frame: .zero)
        backgroundColor = .white
        configureViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    @objc func dismissKeyboard() {
        textFieldDoneButtonTappedDelegate?.textFieldDoneButtonTapped()
    }
    
    // MARK: - UI Setup
    
    private func configureViews() {
        addSubview(viewTitleLabel)
        addSubview(taskFieldView)
        addSubview(tagsBoxView)
        
        taskFieldView.inputAccessoryView = keyboardToolbar
        taskFieldView.text = "\(selectedToDoItem.task ?? "")"
        
        NSLayoutConstraint.activate([
            viewTitleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            viewTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            taskFieldView.topAnchor.constraint(equalTo: viewTitleLabel.bottomAnchor, constant: 20),
            taskFieldView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            taskFieldView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            taskFieldView.heightAnchor.constraint(equalToConstant: 150),
            
            tagsBoxView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30),
            tagsBoxView.centerXAnchor.constraint(equalTo: centerXAnchor),
            tagsBoxView.heightAnchor.constraint(equalToConstant: 300),
            tagsBoxView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.90),
        ])
    }

}
