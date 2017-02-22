//
//  FirstStartApp.swift
//  ReactionApp
//
//  Created by Руслан on 18.02.17.
//  Copyright © 2017 Ruslan Timchenko. All rights reserved.
//

import Foundation
import RealmSwift

class FirstStartApp: Object {
    
    private let backgroundQueue = DispatchQueue(label: "com.rstimchenko.backgroundQueue")
    
    dynamic var isFirstStart = true // default
    
    func save() {
        backgroundQueue.sync {
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(self)
                }
            } catch let error as NSError {
                fatalError(error.localizedDescription)
            }
        }
    }
}






