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
                    self.dataSource.tasks.remove(at: indexPath.row)
                    deleteActionClosure?(indexPath)
                    completion(true)
                }
                return UISwipeActionsConfiguration(actions: [deleteAction])
            }
            
            config.leadingSwipeActionsConfigurationProvider = { indexPath in
                let title = self.dataSource.tasks[indexPath.row].status ? "Undo" : "Complete"
                let completeAction = UIContextualAction(style: .normal, title: title) { [weak self] action, view, completion in
                    guard let self = self else { return }
                    self.dataSource.tasks[indexPath.row].changeCompletedStatus()
                    completeActionClosure?(indexPath)
                    completion(true)
                }
                completeAction.backgroundColor = .systemGray
                
                return UISwipeActionsConfiguration(actions: [completeAction])
            }

            let layoutSection = NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
            return layoutSection
        }
        return layout
    }()
    
    lazy var addTaskButton: UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 32, weight: .light, scale: .default)
        let largePlus = UIImage(systemName: "plus.app.fill", withConfiguration: largeConfig)
        button.setImage(largePlus, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var errorAlert: UIAlertController = {
        let alert = UIAlertController(title: "Error", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        return alert
    }()
    
    lazy var emptyTasksLabel = LabelsFactory.createLabel(with: "Create your first task", isTextBold: true)
    
    let dataSource = ToDoListMainCollectionViewDataSource()
    
    var deleteActionClosure: ((IndexPath) -> Void)?
    var completeActionClosure: ((IndexPath) -> Void)?
    
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
        addSubview(emptyTasksLabel)
        
        emptyTasksLabel.isHidden = true
        
        setupConstraints()
    }
    
    func setupConstraints() {
        let constraint = [
            taskCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            taskCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            taskCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            taskCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            emptyTasksLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyTasksLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ]
        
        NSLayoutConstraint.activate(constraint)
    }
}


