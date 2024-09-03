//
//  ToDoListRouter.swift
//  ToDoList
//
//  Created by Александра Сергеева on 30.08.2024.
//

import UIKit

protocol IToDoListRouter {
    func showEditTaskScreen(_ taskId: String)
}

final class ToDoListRouter: IToDoListRouter {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showEditTaskScreen(_ taskId: String) {
        let viewController = EditTaskAssembly.createEditTaskModule(with: taskId)
        navigationController.pushViewController(viewController, animated: true)
    }
}
