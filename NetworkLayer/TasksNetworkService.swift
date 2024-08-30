//
//  PointsNetworkService.swift
//  ToDoList
//
//  Created by Александра Сергеева on 30.08.2024.
//

import Foundation

protocol ITasksNetworkService {
    func getDefaultPoints(completion: @escaping (Result<[TaskScheme], Error>) -> Void)
}

final class TasksNetworkService {
    private let session = URLSession.shared
    private let mapper = JsonDecoderWrapper()
    
}

extension TasksNetworkService: ITasksNetworkService {
    func getDefaultPoints(completion: @escaping (Result<[TaskScheme], Error>) -> Void) {
        guard let request = makeURLRequest(endpoint: "https://dummyjson.com/todos") else {
            completion(.failure(NetworkErrors.invalidRequest))
            return
        }
        fetchPoints(with: request, completion: completion)
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
    
    func fetchPoints(with request: URLRequest, completion: @escaping (Result<[TaskScheme], Error>) -> Void) {
        fetchData(with: request, responseType: TaskResponceScheme.self) { result in
            switch result {
            case .success(let model):
                completion(.success(model.todos))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func makeURLRequest(endpoint: String) -> URLRequest? {
        var urlComponents = URLComponents(string: endpoint)
        
        guard let url = urlComponents?.url else {
            return nil
        }
        return URLRequest(url: url)
    }
}
    
