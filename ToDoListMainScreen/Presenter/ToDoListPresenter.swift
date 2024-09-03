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
    func taskClicked(at index: Int)
    func createTaskClicked()
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
        interactor.fetchTasks { [weak self] result in
            switch result {
            case .success(let tasks):
                self?.tasks = tasks
                if tasks.isEmpty {
                    self?.ui?.showEmptyTasks()
                } else {
                    self?.ui?.showTasks(tasks)
                }
            case .failure(let error):
                self?.ui?.showError(error.localizedDescription)
            }
        }
    }
    
    func taskDeleted(_ index: Int) {
        interactor.deleteTask(index) { [weak self] result in
            switch result {
            case .success(let tasks):
                if tasks.isEmpty {
                    self?.ui?.showEmptyTasks()
                }
            case .failure(let failure):
                self?.ui?.showError(failure.localizedDescription)
            }
        }
    }
    
    func taskClicked(at index: Int) {
        router.showEditTaskScreen(tasks[index].id)
    }
    
    func createTaskClicked() {
        interactor.createEmptyTask { [weak self] result in
            switch result {
            case .success(let taskId):
                self?.router.showEditTaskScreen(taskId)
            case .failure(let failure):
                self?.ui?.showError(failure.localizedDescription)
            }
        }
    }
}

