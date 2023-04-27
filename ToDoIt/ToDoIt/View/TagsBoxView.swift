//
//  TagsBoxView.swift
//  ToDoIt
//
//  Created by Caroline Frey on 3/9/23.
//

import UIKit

protocol PresentNewTagViewDelegate: AnyObject {
    func presentNewTagView()
}

class TagsBoxView: UIView {
    
    var presentNewTagViewDelegate: PresentNewTagViewDelegate?

    // MARK: - UI Properties
    
    let tagBoxView: UIView = {
        let box = UIView()
        box.translatesAutoresizingMaskIntoConstraints = false
        box.backgroundColor = UIColor(named: "tagsBoxBackground")
        box.layer.cornerRadius = 10
        return box
    }()
    
    let tagBoxTitle: UILabel = {
        let tag = UILabel()
        tag.translatesAutoresizingMaskIntoConstraints = false
        tag.font = .boldSystemFont(ofSize: 26)
        tag.textColor = .black
        tag.text = "Tags"
        return tag
    }()
    
    lazy var newTagButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(textStyle: .title2)
        let icon = UIImage(systemName: "plus.circle", withConfiguration: config)
        button.setImage(icon, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(newTagButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 10
        tableView.rowHeight = 30
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: "tagsBoxBackground")
        return tableView
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    @objc func newTagButtonTapped() {
        presentNewTagViewDelegate?.presentNewTagView()
    }

    // MARK: - UI Setup

    private func configureViews() {
        addSubview(tagBoxView)
        addSubview(tagBoxTitle)
        addSubview(newTagButton)
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tagBoxView.topAnchor.constraint(equalTo: topAnchor),
            tagBoxView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tagBoxView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tagBoxView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            tagBoxTitle.topAnchor.constraint(equalTo: tagBoxView.topAnchor, constant: 10),
            tagBoxTitle.leadingAnchor.constraint(equalTo: tagBoxView.leadingAnchor, constant: 10),
            
            newTagButton.topAnchor.constraint(equalTo: tagBoxView.topAnchor, constant: 10),
            newTagButton.trailingAnchor.constraint(equalTo: tagBoxView.trailingAnchor, constant: -10),
            
            tableView.topAnchor.constraint(equalTo: tagBoxTitle.bottomAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: tagBoxView.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: tagBoxView.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: tagBoxView.bottomAnchor, constant: -10),
        ])
    }
}
