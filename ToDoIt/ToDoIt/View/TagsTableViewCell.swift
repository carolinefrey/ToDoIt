//
//  TagsTableViewCell.swift
//  ToDoIt
//
//  Created by Caroline Frey on 4/6/23.
//

import UIKit

class TagsTableViewCell: UITableViewCell {

    static let tagsTableViewCellIdentifier = "TagsTableViewCell"
    
    // MARK: - UI Properties
    
    let tagView: UILabel = {
        let tag = UILabel()
        tag.translatesAutoresizingMaskIntoConstraints = false
        tag.font = .systemFont(ofSize: 18)
        tag.textColor = .black
        tag.backgroundColor = .lightGray
        return tag
    }()
    
    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions

    func configureTag(tag: String) {
        tagView.text = tag
    }
    
    // MARK: - UI Setup
    
    private func configureViews() {
        addSubview(tagView)
        
        NSLayoutConstraint.activate([
            tagView.topAnchor.constraint(equalTo: topAnchor),
            tagView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tagView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tagView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
