//
//  ToDoListCollectionViewDataSource.swift
//  ToDoList
//
//  Created by Александра Сергеева on 29.08.2024.
//

import UIKit

final class ToDoListMainCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    var tasks: [TaskModel] = []
    
    func setTasks(_ tasks: [TaskModel]) {
        self.tasks = tasks
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ToDoListCollectionViewCell.identifier,
            for: indexPath) as? ToDoListCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        let task = tasks[indexPath.item]
        cell.fillCellWith(task)
        
        return cell
    }
}
