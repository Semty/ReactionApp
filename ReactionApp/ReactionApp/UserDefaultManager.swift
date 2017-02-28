//
//  UserDefaultManager.swift
//  ReactionApp
//
//  Created by Руслан on 28.02.17.
//  Copyright © 2017 Ruslan Timchenko. All rights reserved.
//

import UIKit

enum UserDefaultManagerKeys: String {
    case kSimpleStartApp
    case kFirstStartApp
    case kNotificationsOn
    case kRingTime
}

class UserDefaultManager: UserDefaults {
    
    static let shared = UserDefaultManager() // Singletone
    
    let kSimpleStartApp     = "kSimpleStartApp"
    let kFirstStartApp      = "kFirstStartApp"
    let kNotificationsOn    = "kNotificationsOn"
    let kRingTime           = "kRingTime"

    // MARK: - Save/Load Functions
    
    func save(value: Any, forKey key: UserDefaultManagerKeys) {
        
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    func loadValue(forKey key: UserDefaultManagerKeys) -> Any? {
        
        return UserDefaults.standard.value(forKey: key.rawValue) ?? nil
    }
}
