//
//  ToDoListCollectionViewCell.swift
//  ToDoList
//
//  Created by Александра Сергеева on 29.08.2024.
//

import UIKit

class ToDoListCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: ToDoListCollectionViewCell.self)
    
    private lazy var taskTitleLabel = LabelsFactory.createLabel(isTextBold: true, textSize: 19)
    private lazy var taskTextLabel = LabelsFactory.createLabel()
    private lazy var taskCreationDateLabel = LabelsFactory.createLabel()
    private lazy var taskStatusLabel = LabelsFactory.createLabel()
    
    private lazy var taskStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [taskTitleLabel, taskTextLabel, taskCreationDateLabel, taskStatusLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 8
        return stack
    }()
    
    private let offsetForConstraints: CGFloat = 16
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.addSubview(taskStackView)
        
        contentView.backgroundColor = .systemBackground
        
        setupConstraints()
    }
    
    func fillCellWith(_ task: TaskModel) {
        taskStatusLabel.text = task.status ? "Completed" : "Not completed"
        taskCreationDateLabel.text = task.creationDate
        if let title = task.title, !title.isEmpty {
            taskTitleLabel.text = title
        } else {
            taskTitleLabel.text = "Title"
        }
        
        if let text = task.description, !text.isEmpty {
            taskTextLabel.text = text
        } else {
            taskTextLabel.text = "No additional info"
        }
    }
}

private extension ToDoListCollectionViewCell {
    func setupConstraints() {
        let constraints = [
            taskStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            taskStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: offsetForConstraints),
            taskStackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -offsetForConstraints),
            taskStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
            
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
