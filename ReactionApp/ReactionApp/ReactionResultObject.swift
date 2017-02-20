//
//  ReactionResultObject.swift
//  ReactionApp
//
//  Created by Руслан on 18.02.17.
//  Copyright © 2017 Ruslan Timchenko. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class ReactionResultObject: Object {
    
    dynamic var reactionTime = 0
    dynamic var reactionDateSince1970 = TimeInterval()
    
    func save() {
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
