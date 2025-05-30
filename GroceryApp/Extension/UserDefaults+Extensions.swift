//
//  UserDefaults+Extensions.swift
//  GroceryApp
//
//  Created by Tayfun Ilker on 30.05.25.
//

import Foundation

extension UserDefaults {
    var userId: UUID? {
        get {
            guard let userIdAsString = string(forKey: "userId") else {
                return nil
            }
            return UUID(uuidString: userIdAsString)
        }
        
        set {
            set(newValue?.uuidString, forKey: "userId")
        }
    }
}
