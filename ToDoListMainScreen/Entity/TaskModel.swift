//
//  ToDoListTaskModel.swift
//  ToDoList
//
//  Created by Александра Сергеева on 29.08.2024.
//

import Foundation

struct TaskModel {
    let title: String?
    let description: String?
    let creationDate: String
    let id: String
    var status: Bool
    
    mutating func changeCompletedStatus() {
        self.status = !status
    }

}
