//
//  ToDoListCollectionViewCell.swift
//  ToDoList
//
//  Created by Александра Сергеева on 29.08.2024.
//

import UIKit

class ToDoListCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: ToDoListCollectionViewCell.self)
    
    private lazy var taskTitleLabel = LabelsFactory.createLabel(isTextBold: true)
    private lazy var taskTextLabel = LabelsFactory.createLabel(textSize: 18)
    private lazy var taskCreationDateLabel = LabelsFactory.createLabel(textSize: 18)
    private lazy var taskStatusLabel = LabelsFactory.createLabel(textSize: 18)
    
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
        contentView.addSubview(taskTitleLabel)
        contentView.addSubview(taskTextLabel)
        contentView.addSubview(taskCreationDateLabel)
        contentView.addSubview(taskStatusLabel)
        
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.gray.withAlphaComponent(0.2).cgColor
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        setupConstraints()
    }
    
    func fillCellWith(_ task: TaskModel) {
        taskTextLabel.text = task.description
        taskStatusLabel.text = task.status ? "Completed" : "Not completed"
        taskCreationDateLabel.text = task.creationDate
        guard let title = task.title else {
            taskTitleLabel.text = "Title"
            return
        }
        taskTitleLabel.text = title
    }
}

private extension ToDoListCollectionViewCell {
    func setupConstraints() {
        let constraints = [
            taskTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: offsetForConstraints),
            taskTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: offsetForConstraints),
            taskTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -offsetForConstraints),
            
            taskTextLabel.topAnchor.constraint(equalTo: taskTitleLabel.bottomAnchor, constant: offsetForConstraints),
            taskTextLabel.leadingAnchor.constraint(equalTo: taskTitleLabel.leadingAnchor),
            taskTextLabel.trailingAnchor.constraint(equalTo: taskTitleLabel.trailingAnchor),
            
            taskCreationDateLabel.topAnchor.constraint(equalTo: taskTextLabel.bottomAnchor, constant: offsetForConstraints),
            taskCreationDateLabel.leadingAnchor.constraint(equalTo: taskTitleLabel.leadingAnchor),
            taskCreationDateLabel.trailingAnchor.constraint(equalTo: taskTitleLabel.trailingAnchor),
            
            taskStatusLabel.topAnchor.constraint(equalTo: taskCreationDateLabel.bottomAnchor, constant: offsetForConstraints),
            taskStatusLabel.leadingAnchor.constraint(equalTo: taskTitleLabel.leadingAnchor),
            taskStatusLabel.trailingAnchor.constraint(equalTo: taskTitleLabel.trailingAnchor),
            taskStatusLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -offsetForConstraints),
            
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
