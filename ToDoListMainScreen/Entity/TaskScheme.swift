//
//  TaskResponceScheme.swift
//  ToDoList
//
//  Created by Александра Сергеева on 30.08.2024.
//

import Foundation

struct TaskResponceScheme: Codable {
    let todos: [TaskScheme]
    let total, skip, limit: Int
}

struct TaskScheme: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case id, todo, completed
        case userID = "userId"
    }
}
