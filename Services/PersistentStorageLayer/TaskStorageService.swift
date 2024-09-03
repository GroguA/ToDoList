//
//  TaskStorageService.swift
//  ToDoList
//
//  Created by Александра Сергеева on 30.08.2024.
//

import UIKit
import CoreData

protocol ITaskStorageService {
    func fetchTasks() throws -> [TaskStorageModel]
    func createTask(title: String?, text: String?) throws -> String
    func getTaskById(_ id: String) throws -> TaskStorageModel?
    func updateTaskById(_ id: String, title: String?, text: String?) throws
}

final class TaskStorageService {
    static let shared = TaskStorageService()
    
    private let persistentContainer: NSPersistentContainer
    
    private init(persistentContainer: NSPersistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    private var managedContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}

extension TaskStorageService: ITaskStorageService {
    func fetchTasks() throws -> [TaskStorageModel] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let taskManagedObjs = try managedContext.fetch(fetchRequest)
        
        return taskManagedObjs.compactMap { managedTask in
            guard let title = managedTask.value(forKey: "title") as? String,
                  let text = managedTask.value(forKey: "text") as? String,
                  let creationDate = managedTask.value(forKey: "creationDate") as? Date,
                  let status = managedTask.value(forKey: "status") as? Bool else {
                return nil
            }
            
            return TaskStorageModel(
                title: title,
                text: text,
                creationDate: creationDate,
                id: managedTask.objectID.uriRepresentation().absoluteString,
                status: status
            )
        }
    }
    
    func createTask(title: String?, text: String?) throws -> String {
        let entity = try getEntity(named: "Task")
        let taskManagedObject = NSManagedObject(entity: entity, insertInto: managedContext)
                
        taskManagedObject.setValue(title, forKey: "title")
        taskManagedObject.setValue(text, forKey: "text")
        taskManagedObject.setValue(false, forKey: "status")
        taskManagedObject.setValue(Date(), forKey: "creationDate")
        
        try saveContext()
        return taskManagedObject.objectID.uriRepresentation().absoluteString
    }
    
    func getTaskById(_ id: String) throws -> TaskStorageModel? {
        let taskManagedObj = try getManagedObjectById(id)
        
        guard let title = taskManagedObj.value(forKey: "title") as? String?,
              let text = taskManagedObj.value(forKey: "text") as? String?,
              let creationDate = taskManagedObj.value(forKey: "creationDate") as? Date,
              let status = taskManagedObj.value(forKey: "status") as? Bool else {
            return nil
        }
        
        return TaskStorageModel(
            title: title,
            text: text,
            creationDate: creationDate,
            id: taskManagedObj.objectID.uriRepresentation().absoluteString,
            status: status
        )
    }
    
    func updateTaskById(_ id: String, title: String?, text: String?) throws {
        let taskManagedObj = try getManagedObjectById(id)
        
        guard let title, let text else { return }
        guard !title.isEmpty || !text.isEmpty else {
            try deleteTask(id: id)
            return
        }
        
        taskManagedObj.setValue(title, forKey: "title")
        taskManagedObj.setValue(text, forKey: "text")
        taskManagedObj.setValue(Date(), forKey: "creationDate")
        
        try saveContext()
    }
    
    func deleteTask(id: String) throws {
        let taskManagedObj = try getManagedObjectById(id)
        managedContext.delete(taskManagedObj)
        try saveContext()
    }
}

private extension TaskStorageService {
    func getEntity(named name: String) throws -> NSEntityDescription {
        guard let entity = NSEntityDescription.entity(forEntityName: name, in: managedContext) else {
            throw StorageErrors.runtimeError("No entity for name: \(name)")
        }
        return entity
    }
    
    func getManagedObjectById(_ id: String) throws -> NSManagedObject {
        guard let url = URL(string: id),
              let taskId = persistentContainer.persistentStoreCoordinator.managedObjectID(forURIRepresentation: url) else {
            throw StorageErrors.runtimeError("Failed to retrieve object for id: \(id)")
        }
        return managedContext.object(with: taskId)
    }
    
    func saveContext() throws {
        do {
            try managedContext.save()
        } catch {
            throw StorageErrors.runtimeError("Failed to save context: \(error.localizedDescription)")
        }
    }
}

