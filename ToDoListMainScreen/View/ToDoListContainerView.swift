//
//  ToDoListContainerView.swift
//  ToDoList
//
//  Created by Александра Сергеева on 29.08.2024.
//

import UIKit

final class ToDoListContainerView: UIView {
    lazy var taskCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = dataSource
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ToDoListCollectionViewCell.self, forCellWithReuseIdentifier: ToDoListCollectionViewCell.identifier)
        return collectionView
    }()
    
    private lazy var layout: UICollectionViewCompositionalLayout = {
        let layout = UICollectionViewCompositionalLayout() { section, layoutEnvironment in
            var config = UICollectionLayoutListConfiguration(appearance: .plain)

            config.trailingSwipeActionsConfigurationProvider = { indexPath in
                let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
                    [weak self] action, view, completion in
                    guard let self else { return }
                    self.deleteActionClosure(self.dataSource.tasks[indexPath.row].id)
                    completion(true)
                }
                return UISwipeActionsConfiguration(actions: [deleteAction])
            }

            config.leadingSwipeActionsConfigurationProvider = { indexPath in
                let completeAction = UIContextualAction(style: .normal, title: "Done") {
                    [weak self] action, view, completion in
                    guard let self else { return }
                    self.completeActionClosure(self.dataSource.tasks[indexPath.row].id)
                    completion(true)
                }
                completeAction.backgroundColor = .systemGreen
                return UISwipeActionsConfiguration(actions: [completeAction])
            }

            let layoutSection = NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
            layoutSection.interGroupSpacing = 8
            return layoutSection
        }
        return layout
    }()

    
    lazy var addTaskButton: UIImageView = {
        let button = UIImageView()
        button.image = UIImage(systemName: "plus.circle.fill")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        return button
    }()
    
    let dataSource = ToDoListMainCollectionViewDataSource()
    
    var deleteActionClosure: ((Int) -> Void) = { _ in }
    var completeActionClosure: ((Int) -> Void) = { _ in }
    
    init(delegate: UICollectionViewDelegate) {
        super.init(frame: .zero)
        taskCollectionView.delegate = delegate
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ToDoListContainerView {
    func setupViews() {
        backgroundColor = .systemBackground
        addSubview(taskCollectionView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        let constraint = [
            taskCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            taskCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            taskCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            taskCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            addTaskButton.widthAnchor.constraint(equalToConstant: 34),
            addTaskButton.heightAnchor.constraint(equalToConstant: 34),
        ]
        
        NSLayoutConstraint.activate(constraint)
    }
}


