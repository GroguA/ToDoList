//
//  TasksNetworkService.swift
//  ToDoList
//
//  Created by Александра Сергеева on 30.08.2024.
//

import Foundation

protocol ITasksNetworkService {
    func getDefaultTasks(completion: @escaping (Result<[TaskScheme], Error>) -> Void)
}

final class TasksNetworkService {
    private let session = URLSession.shared
    private let mapper = JsonDecoderWrapper()
    
}

extension TasksNetworkService: ITasksNetworkService {
    func getDefaultTasks(completion: @escaping (Result<[TaskScheme], Error>) -> Void) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }

            guard let request = self.makeURLRequest("https://dummyjson.com/todos") else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkErrors.invalidRequest))
                }
                return
            }
            self.fetchTasks(with: request) { result in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }

}

private extension TasksNetworkService {
    func fetchData<T: Decodable>(with request: URLRequest, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(NetworkErrors.parseError(message: error.localizedDescription)))
                return
            }
            
            guard let data = data, let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkErrors.invalidResponse))
                return
            }
                        
            switch httpResponse.statusCode {
            case 200..<300:
                self.mapper.parse(responseType, from: data, completion: completion)
            default:
                let errorMessage = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                completion(.failure(NetworkErrors.statusCodeError(message: errorMessage)))
            }
        }
        task.resume()
    }
    
    func fetchTasks(with request: URLRequest, completion: @escaping (Result<[TaskScheme], Error>) -> Void) {
        fetchData(with: request, responseType: TaskResponceScheme.self) { result in
            switch result {
            case .success(let model):
                completion(.success(model.todos))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func makeURLRequest(_ query: String) -> URLRequest? {
        guard let url = URL(string: query) else {
            return nil
        }
        return URLRequest(url: url)
    }
}
    
