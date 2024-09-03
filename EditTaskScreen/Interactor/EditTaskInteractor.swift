//
//  EditTaskInteractor.swift
//  ToDoList
//
//  Created by Александра Сергеева on 31.08.2024.
//

import Foundation

protocol IEditTaskInteractor {
    func getTask(completion: @escaping (Result<EditTaskModel, Error>) -> Void)
    func updateTask(title: String?, text: String?, completion: @escaping (Result<Void, Error>) -> Void) 
}

final class EditTaskInteractor {
    private let storageService: ITaskStorageService
    private let taskId: String
    
    init(taskId: String, storageService: ITaskStorageService) {
        self.storageService = storageService
        self.taskId = taskId
    }
}

extension EditTaskInteractor: IEditTaskInteractor {
    func getTask(completion: @escaping (Result<EditTaskModel, Error>) -> Void) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }
            
            do {
                guard let task = try self.storageService.getTaskById(self.taskId) else {
                    self.callCompletionOnMain(.failure(StorageErrors.runtimeError("Task not found")), completion: completion)
                    return
                }
                let mappedTask = self.mapStorageModelToModel(task)
                self.callCompletionOnMain(.success(mappedTask), completion: completion)
            } catch {
                self.callCompletionOnMain(.failure(error), completion: completion)
            }
        }
    }
    
    func updateTask(title: String?, text: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self else { return }
                do {
                    try self.storageService.updateTaskById(self.taskId, title: title, text: text, status: nil)
                } catch {
                    self.callCompletionOnMain(.failure(error), completion: completion)
                }
            }
        }
}

private extension EditTaskInteractor {
    func mapStorageModelToModel(_ storageModel: TaskStorageModel) -> EditTaskModel {
        return EditTaskModel(title: storageModel.title, text: storageModel.text, id: storageModel.id)
    }
    
    func callCompletionOnMain<T>(_ result: Result<T, Error>, completion: @escaping (Result<T, Error>) -> Void) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
}
