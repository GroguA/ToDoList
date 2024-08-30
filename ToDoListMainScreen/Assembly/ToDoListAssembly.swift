//
//  ToDoListAssembly.swift
//  ToDoList
//
//  Created by Александра Сергеева on 30.08.2024.
//

import UIKit

enum ToDoListAssembly {
    static func createToDoListListModule(with navigationController: UINavigationController) -> UIViewController {
        let interactor = ToDoListInteractor()
        let router = ToDoListRouter(navigationController: navigationController)
        let presenter = ToDoListPresenter(interactor: interactor, router: router)
        let view = ToDoListViewController(presenter: presenter)
        return view
    }
}
