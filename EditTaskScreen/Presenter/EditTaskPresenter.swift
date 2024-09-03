//
//  EditTaskPresenter.swift
//  ToDoList
//
//  Created by Александра Сергеева on 31.08.2024.
//

import Foundation

protocol IEditTaskPresenter {
    func didLoad(ui: IEditTaskViewController)
    func taskChanged(title: String?, text: String?)
}

final class EditTaskPresenter {
    private weak var ui: IEditTaskViewController?
    
    private let interactor: IEditTaskInteractor
    
    init(interactor: IEditTaskInteractor) {
        self.interactor = interactor
    }
}

extension EditTaskPresenter: IEditTaskPresenter {
    func didLoad(ui: IEditTaskViewController) {
        self.ui = ui
        interactor.getTask() { [weak self] result in
            switch result {
            case .success(let task):
                self?.ui?.showTask(task)
            case .failure(let failure):
                self?.ui?.showError(failure.localizedDescription)
            }
        }
    }
    
    func taskChanged(title: String?, text: String?) {
        interactor.updateTask(title: title, text: text) { [weak self] result in
            switch result {
            case .success(_):
                return
            case .failure(let failure):
                self?.ui?.showError(failure.localizedDescription)
            }
        }
    }

}
