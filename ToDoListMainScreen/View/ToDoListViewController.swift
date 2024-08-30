//
//  ToDoListViewController.swift
//  ToDoList
//
//  Created by Александра Сергеева on 29.08.2024.
//

import UIKit

protocol IToDoListController: AnyObject {
    func showTasks(_ tasks: [TaskModel])
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.didLoad(ui: self)
        setupViews()
    }
    
}

extension ToDoListViewController: IToDoListController {
    func showTasks(_ tasks: [TaskModel]) {
        callResultOnMain { [weak self] in
            self?.containerView.taskCollectionView.isHidden = false
            self?.containerView.dataSource.setTasks(tasks)
            self?.containerView.taskCollectionView.reloadData()
        }
    }
    
}

extension ToDoListViewController: UICollectionViewDelegate {
    
}

private extension ToDoListViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "ToDo List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: containerView.addTaskButton)
    }
    
    func callResultOnMain(result: @escaping () -> Void) {
        DispatchQueue.main.async {
            result()
        }
    }
}
