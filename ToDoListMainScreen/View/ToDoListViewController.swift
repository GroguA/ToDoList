//
//  ToDoListViewController.swift
//  ToDoList
//
//  Created by Александра Сергеева on 29.08.2024.
//

import UIKit

protocol IToDoListController: AnyObject {
    func showTasks(_ tasks: [TaskModel])
    func showError(_ error: String)
    func showEmptyTasks()
}

final class ToDoListViewController: UIViewController {
    private lazy var containerView = ToDoListContainerView(delegate: self)
    private let presenter: IToDoListPresenter
    
    init(presenter: IToDoListPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = containerView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.didLoad(ui: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        containerView.deleteActionClosure = { [weak self] index in
            guard let self = self else { return }
            self.presenter.taskDeleted(index.row)
            self.containerView.taskCollectionView.performBatchUpdates({
                self.containerView.taskCollectionView.deleteItems(at: [index])
            }, completion: nil)
        }
        
        containerView.completeActionClosure = { [weak self] index in
            guard let self = self else { return }
            self.presenter.taskStatusChanged(index.row) { tasks in
                self.containerView.dataSource.setTasks(tasks)
                self.containerView.taskCollectionView.reloadData()
            }
        }
        
    }
}

extension ToDoListViewController: IToDoListController {
    func showTasks(_ tasks: [TaskModel]) {
        containerView.taskCollectionView.isHidden = false
        containerView.dataSource.setTasks(tasks)
        containerView.emptyTasksLabel.isHidden = true
        containerView.taskCollectionView.reloadData()
    }
    
    func showError(_ error: String) {
        containerView.taskCollectionView.isHidden = true
        containerView.errorAlert.message = error
        present(containerView.errorAlert, animated: true)
    }
    
    func showEmptyTasks() {
        containerView.emptyTasksLabel.isHidden = false
        containerView.taskCollectionView.isHidden = true
    }
}

extension ToDoListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.taskClicked(at: indexPath.row)
    }
}

private extension ToDoListViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "ToDo List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: containerView.addTaskButton)
        
        containerView.addTaskButton.addTarget(self, action: #selector(onCreateTaskTapped), for: .touchUpInside)
    }
    
    @objc func onCreateTaskTapped() {
        presenter.createTaskClicked()
        containerView.taskCollectionView.reloadData()
    }
}
