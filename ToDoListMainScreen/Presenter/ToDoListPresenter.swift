//
//  ToDoListPresenter.swift
//  ToDoList
//
//  Created by Александра Сергеева on 29.08.2024.
//

import Foundation

protocol IToDoListPresenter {
    func didLoad(ui: IToDoListController)
    func taskDeleted(_ index: Int)
}

final class ToDoListPresenter {
    private weak var ui: IToDoListController?
    private var tasks = [TaskModel]()
    private let interactor: IToDoListInteractor
    private let router: IToDoListRouter
    
    init(interactor: IToDoListInteractor, router: IToDoListRouter) {
        self.interactor = interactor
        self.router = router
    }
}


extension ToDoListPresenter: IToDoListPresenter {
    func didLoad(ui: IToDoListController) {
        self.ui = ui
        interactor.fetchPoints { [weak self] result in
            switch result {
            case .success(let tasks):
                self?.tasks = tasks
                self?.ui?.showTasks(tasks)
            case .failure(_): break
                
            }
        }
    }
    
    func taskDeleted(_ index: Int) {
        interactor.deleteTask(index)
    }
}

