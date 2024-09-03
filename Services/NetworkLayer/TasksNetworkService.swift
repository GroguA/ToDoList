//
//  PointsNetworkService.swift
//  ToDoList
//
//  Created by Александра Сергеева on 30.08.2024.
//

import Foundation

protocol ITasksNetworkService {
    func getDefaultTasks(completion: @escaping (Result<[TaskScheme], Error>) -> Void)
}

final class TasksNetworkService {
    static let shared = TasksNetworkService()
    
    private init() {}
    
    private let session = URLSession.shared
    private let mapper = JsonDecoderWrapper()
    
}

extension TasksNetworkService: ITasksNetworkService {
    func getDefaultTasks(completion: @escaping (Result<[TaskScheme], Error>) -> Void) {
        guard let request = makeURLRequest("https://dummyjson.com/todos") else {
            completion(.failure(NetworkErrors.invalidRequest))
            return
        }
        fetchTasks(with: request, completion: completion)
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
    
