//
//  CompletedTasksView.swift
//  ToDoIt
//
//  Created by Caroline Frey on 4/27/23.
//

import UIKit

class CompletedTasksView: UIView {
    
    // MARK: - UI Properties
        
    let viewTitleLabel: UILabel = {
        let viewTitle = UILabel()
        viewTitle.translatesAutoresizingMaskIntoConstraints = false
        viewTitle.font = .boldSystemFont(ofSize: 38)
        viewTitle.text = "Completed Tasks"
        viewTitle.textColor = UIColor(named: "text")
        viewTitle.textAlignment = .left
        return viewTitle
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "background")
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    private func configureViews() {
        addSubview(viewTitleLabel)
        
        NSLayoutConstraint.activate([
            viewTitleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            viewTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
        ])
    }

}
