//
//  LaunchManager.swift
//  ToDoList
//
//  Created by Александра Сергеева on 02.09.2024.
//

import Foundation

final class LaunchManager {
    static let shared = LaunchManager()
    
    private let hasLaunchedKey = "hasLaunchedBefore"
    
    private let defaults = UserDefaults.standard
    
    private init() {}

    func isFirstLaunch() -> Bool {
        if defaults.bool(forKey: hasLaunchedKey) {
            return false
        } else {
            defaults.set(true, forKey: hasLaunchedKey)
//            defaults.synchronize()  // Синхронизация не обязательна в современных версиях iOS
            return true
        }
    }

}
