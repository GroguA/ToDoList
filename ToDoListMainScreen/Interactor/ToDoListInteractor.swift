//
//  ToDoListInteractor.swift
//  ToDoList
//
//  Created by Александра Сергеева on 29.08.2024.
//

import Foundation

protocol IToDoListInteractor {
    func fetchPoints(completion: @escaping (Result<[TaskModel], Error>) -> Void)
}

final class ToDoListInteractor {
    private let networkService = TasksNetworkService()
    private var currentTasks = [TaskModel]()
}

extension ToDoListInteractor: IToDoListInteractor {
    func fetchPoints(completion: @escaping (Result<[TaskModel], Error>) -> Void) {
        networkService.getDefaultTasks { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let tasks):
                let mappedTasks = self.mapTasksSchemeToMoviesModel(tasks)
                self.currentTasks = mappedTasks
                completion(.success(mappedTasks))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

private extension ToDoListInteractor {
    func mapTasksSchemeToMoviesModel(_ tasks: [TaskScheme]) -> [TaskModel] {
        var mappedTasks = [TaskModel]()
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        tasks.forEach { taskScheme in
            let mappedTask = TaskModel(
                title: nil,
                description: taskScheme.todo,
                creationDate: dateFormatter.string(from: currentDate), 
                id: taskScheme.id,
                status: taskScheme.completed
            )
            mappedTasks.append(mappedTask)
        }
        return mappedTasks
    }
}
