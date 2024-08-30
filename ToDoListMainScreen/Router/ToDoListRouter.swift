//
//  ToDoListRouter.swift
//  ToDoList
//
//  Created by Александра Сергеева on 30.08.2024.
//

import UIKit

protocol IToDoListRouter {
    
}

final class ToDoListRouter: IToDoListRouter {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
