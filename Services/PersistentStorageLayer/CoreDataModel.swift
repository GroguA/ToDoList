//
//  TaskСoreDataModel.swift
//  ToDoList
//
//  Created by Александра Сергеева on 30.08.2024.
//

import Foundation

struct TaskStorageModel {
    let title: String?
    let text: String?
    let creationDate: Date
    let id: String
    let status: Bool
}
