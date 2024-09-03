//
//  ToDoListInteractor.swift
//  ToDoList
//
//  Created by Александра Сергеева on 29.08.2024.
//

import Foundation

protocol IToDoListInteractor {
    func fetchTasks(completion: @escaping (Result<[TaskModel], Error>) -> Void)
    func deleteTask(_ index: Int, completion: @escaping (Result<[TaskModel], Error>) -> Void)
    func createEmptyTask(completion: @escaping (Result<String, Error>) -> Void)
    func changeTaskStatus(_ index: Int, completion: @escaping (Result<[TaskModel], Error>) -> Void)
    func taskClicked(completion: (Bool) -> Void)
}

final class ToDoListInteractor {
    private let networkService: TasksNetworkService
    private let storageService: TaskStorageService
    private let launchManager: LaunchManager
    
    private let syncQueue = DispatchQueue(label: "taskSyncQueue", attributes: .concurrent)
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    private var currentTasks = [TaskModel]()
    
    var userTaskCreated = false
    
    init(
        networkService: TasksNetworkService,
        storageService: TaskStorageService,
        launchManager: LaunchManager = .shared
    ) {
        self.networkService = networkService
        self.storageService = storageService
        self.launchManager = launchManager
    }
}

extension ToDoListInteractor: IToDoListInteractor {
    func fetchTasks(completion: @escaping (Result<[TaskModel], Error>) -> Void) {
        if launchManager.isFirstLaunch() {
            fetchTasksFromNetwork(completion: completion)
        } else {
            fetchTasksFromStorage(completion: completion)
        }
    }
    
    func deleteTask(_ index: Int, completion: @escaping (Result<[TaskModel], Error>) -> Void) {
        if !userTaskCreated {
            self.currentTasks.remove(at: index)
            return
        }
        
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self else { return }
            
            syncQueue.async(flags: .barrier) {
                guard index >= 0 && index < self.currentTasks.count else {
                    self.callCompletionOnMain(.failure(StorageErrors.runtimeError("Index out of range")), completion: completion)
                    return
                }
                
                do {
                    try self.storageService.deleteTask(id: self.currentTasks[index].id)
                    self.currentTasks.remove(at: index)
                    self.callCompletionOnMain(.success(self.currentTasks), completion: completion)
                } catch {
                    self.callCompletionOnMain(.failure(error), completion: completion)
                }
            }
        }
    }
    
    func changeTaskStatus(_ index: Int, completion: @escaping (Result<[TaskModel], Error>) -> Void) {
        if !userTaskCreated {
            currentTasks[index].changeCompletedStatus()
            let updatedTask = self.currentTasks.remove(at: index)
            self.currentTasks.insert(updatedTask, at: 0)
            completion(.success(currentTasks))
            return
        }
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }
            
            syncQueue.async(flags: .barrier) {
                do {
                    let currentTask = self.currentTasks[index]
                    try self.storageService.updateTaskById(currentTask.id, title: currentTask.title, text: currentTask.description, status: !currentTask.status)
                    
                    self.fetchTasksFromStorage { result in
                        switch result {
                        case .success(let tasks):
                            self.currentTasks = tasks
                            self.callCompletionOnMain(.success(tasks), completion: completion)
                        case .failure(let error):
                            self.callCompletionOnMain(.failure(error), completion: completion)
                        }
                    }
                } catch {
                    self.callCompletionOnMain(.failure(error), completion: completion)
                }
            }
        }
    }
    
    func createEmptyTask(completion: @escaping (Result<String, Error>) -> Void) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self else { return }
            
            do {
                let taskId = try self.storageService.createTask(title: nil, text: nil)
                self.userTaskCreated = true
                    self.callCompletionOnMain(.success(taskId), completion: completion)
            } catch {
                self.callCompletionOnMain(.failure(error), completion: completion)
            }
        }
    }
    
    func taskClicked(completion: (Bool) -> Void) {
        completion(userTaskCreated)
    }
    
}

private extension ToDoListInteractor {
    func mapTasksSchemeToTasksModel(_ tasks: [TaskScheme]) -> [TaskModel] {
        return tasks.map { taskScheme in
            TaskModel(
                title: nil,
                description: taskScheme.todo,
                creationDate: dateFormatter.string(from: Date()),
                id: String(taskScheme.id),
                status: taskScheme.completed
            )
        }
    }
    
    func mapTasksStorageToTasksModel(_ tasks: [TaskStorageModel]) -> [TaskModel] {
        return tasks.map { taskStorage in
            TaskModel(
                title: taskStorage.title,
                description: taskStorage.text,
                creationDate: dateFormatter.string(from: Date()),
                id: taskStorage.id,
                status: taskStorage.status
            )
        }
    }
    
    func callCompletionOnMain<T>(_ result: Result<T, Error>, completion: @escaping (Result<T, Error>) -> Void) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
    
    func fetchTasksFromNetwork(completion: @escaping (Result<[TaskModel], Error>) -> Void) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self else { return }
            networkService.getDefaultTasks { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let tasks):
                    let mappedTasks = self.mapTasksSchemeToTasksModel(tasks)
                    self.currentTasks = mappedTasks
                    self.callCompletionOnMain(.success(mappedTasks), completion: completion)
                case .failure(let error):
                    self.callCompletionOnMain(.failure(error), completion: completion)
                }
            }
        }
    }
    
    func fetchTasksFromStorage(completion: @escaping (Result<[TaskModel], Error>) -> Void) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }
            
            do {
                let tasks = try self.storageService.fetchTasks()
                let mappedTasks = self.mapTasksStorageToTasksModel(tasks)
                self.currentTasks = mappedTasks
                self.callCompletionOnMain(.success(mappedTasks), completion: completion)
            } catch let error {
                self.callCompletionOnMain(.failure(error), completion: completion)
            }
        }
    }
}
