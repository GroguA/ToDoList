//
//  EditTaskAssembly.swift
//  ToDoList
//
//  Created by Александра Сергеева on 02.09.2024.
//

import Foundation

enum EditTaskAssembly {
    static func createEditTaskModule(with taskId: String) -> EditTaskViewController {
        let interactor = EditTaskInteractor(taskId: taskId)
        let presenter = EditTaskPresenter(interactor: interactor)
        let view = EditTaskViewController(presenter: presenter)
        return view
    }
}
