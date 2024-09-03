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
    func createTask(title: String, text: String?) throws
    func getTaskById(_ id: UUID) throws -> TaskStorageModel?
    func updateTaskById(id: UUID, title: String?, text: String?) throws
}

final class TaskStorageService {
    static let shared = TaskStorageService()
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    private init() {}
    
}

extension TaskStorageService: ITaskStorageService {
    func fetchTasks() throws -> [TaskStorageModel] {
        var tasks = [TaskStorageModel]()
        
        guard let appDelegate = appDelegate else {
            throw StorageErrors.runtimeError("No app delegate")
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        
        let notesManagedObjects = try managedContext.fetch(fetchRequest)
        notesManagedObjects.forEach({ managedNote in
            guard let title = managedNote.value(forKey: "title") as? String,
                  let text = managedNote.value(forKey: "text") as? String,
                  let creationDate = managedNote.value(forKey: "creationDate") as? Date,
                  let id = managedNote.value(forKey: "id") as? UUID,
                  let status = managedNote.value(forKey: "status") as? Bool
            else {
                return
            }
            let task = TaskStorageModel(
                title: title,
                text: text,
                creationDate: creationDate,
                id: id,
                status: status
            )
            tasks.append(task)
        })
        return tasks
    }
    
    func createTask(title: String, text: String?) throws {
        guard let appDelegate = appDelegate else {
            throw StorageErrors.runtimeError("No app delegate")
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext) else {
            throw StorageErrors.runtimeError("No entity for task")
        }

        let taskManagedObject = NSManagedObject(entity: entity, insertInto: managedContext)

        let id = UUID()

        taskManagedObject.setValue(title, forKey: "title")
        taskManagedObject.setValue(text, forKey: "text")
        taskManagedObject.setValue(id, forKey: "id")
        taskManagedObject.setValue(false, forKey: "status")

        do {
            try managedContext.save()
        } catch {
            throw StorageErrors.runtimeError("Could not save task: \(error.localizedDescription)")
        }
    }

    
    func getTaskById(_ id: UUID) throws -> TaskStorageModel? {
        guard let appDelegate = appDelegate else {
            throw StorageErrors.runtimeError("No app delegate")
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        let fetchedTasks = try managedContext.fetch(fetchRequest)
        
        if let managedTask = fetchedTasks.first {
            guard let title = managedTask.value(forKey: "title") as? String,
                  let text = managedTask.value(forKey: "text") as? String,
                  let creationDate = managedTask.value(forKey: "creationDate") as? Date,
                  let id = managedTask.value(forKey: "id") as? UUID,
                  let status = managedTask.value(forKey: "status") as? Bool
            else {
                return nil
            }
            
            return TaskStorageModel(
                title: title,
                text: text,
                creationDate: creationDate,
                id: id,
                status: status
            )
        }
        return nil
    }

    func updateTaskById(id: UUID, title: String?, text: String?) throws {
        guard let appDelegate = appDelegate else {
            throw StorageErrors.runtimeError("No app delegate")
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let fetchedTasks = try managedContext.fetch(fetchRequest)
            
            guard let taskManagedObject = fetchedTasks.first else {
                throw StorageErrors.runtimeError("Task with ID \(id) not found")
            }
            
            if let title {
                taskManagedObject.setValue(title, forKey: "title")
            }
            
            if let text {
                taskManagedObject.setValue(text, forKey: "text")
            }
            
            try managedContext.save()
            
        } catch {
            throw StorageErrors.runtimeError("Failed to update task: \(error.localizedDescription)")
        }
    }

    
}
