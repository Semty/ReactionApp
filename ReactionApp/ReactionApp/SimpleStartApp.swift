//
//  SimpleStartApp.swift
//  ReactionApp
//
//  Created by Руслан on 26.02.17.
//  Copyright © 2017 Ruslan Timchenko. All rights reserved.
//

import Foundation
import RealmSwift

class SimpleStartApp: Object {
    
    private let backgroundQueue = DispatchQueue(label: "com.rstimchenko.backgroundQueue")
    
    dynamic var isSimpleStart = true // default
    dynamic var simpleStartAppKey = "simpleStartAppKey"
    
    override open class func primaryKey() -> String? { return "simpleStartAppKey" }
    
    func save() {
        backgroundQueue.sync {
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(self, update: realm.objects(SimpleStartApp.self).first != nil ? true : false)
                }
            } catch let error as NSError {
                fatalError(error.localizedDescription)
            }
        }
    }
}
