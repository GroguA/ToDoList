//
//  JsonDecoderWrapper.swift
//  ToDoList
//
//  Created by Александра Сергеева on 30.08.2024.
//

import Foundation

final class JsonDecoderWrapper {
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    func parse<T>(
        _ type: T.Type,
        from data: Data,
        completion: @escaping (Result<T, Error>) -> Void
    ) where T : Decodable {
        do {
            let model = try self.decoder.decode(type, from: data)
            completion(.success(model))
        } catch {
            completion(.failure(error))
        }
    }
}
