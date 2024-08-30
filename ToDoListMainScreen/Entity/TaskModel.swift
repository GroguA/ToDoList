//
//  ToDoListPointModel.swift
//  ToDoList
//
//  Created by Александра Сергеева on 29.08.2024.
//

import Foundation

struct TaskModel {
    let title: String
    let description: String
    let creationDate: Date
    var status: TaskStatus
    
    enum TaskStatus {
        case completed
        case notCompleted
    }
    
    init(title: String, description: String, creationDate: Date = Date(), status: TaskStatus) {
        self.title = title
        self.description = description
        self.creationDate = creationDate
        self.status = status
    }
    
    mutating func markAsCompleted() {
        self.status = .completed
    }
    
    mutating func markAsNotCompleted() {
        self.status = .notCompleted
    }

}
