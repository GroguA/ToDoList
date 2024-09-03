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
    
    private init() {}

    func isFirstLaunch() -> Bool {
        let defaults = UserDefaults.standard
        if !defaults.bool(forKey: hasLaunchedKey) {
            defaults.set(true, forKey: hasLaunchedKey)
            defaults.synchronize()
            return true
        } else {
            return false
        }
    }
}
