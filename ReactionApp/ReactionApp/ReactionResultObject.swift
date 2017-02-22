//
//  ReactionResultObject.swift
//  ReactionApp
//
//  Created by Руслан on 18.02.17.
//  Copyright © 2017 Ruslan Timchenko. All rights reserved.
//

import Foundation
import RealmSwift

class ReactionResultObject: Object {
    
    private let backgroundQueue = DispatchQueue(label: "com.rstimchenko.backgroundQueue")
    
    dynamic var reactionTime        = 0
    
    dynamic var reactionDate        = Date()
    dynamic var reactionWeekday     = 0
    //dynamic var reactionWeekOfMonth = 0
    
    func save() {
        backgroundQueue.sync {
            
            let currentDate = Date.init(timeIntervalSinceNow: 0)
            
            self.reactionDate = currentDate
            self.reactionWeekday = Calendar.current.component(.weekday, from: currentDate)
            //self.reactionWeekOfMonth = Calendar.current.component(.weekOfMonth, from: currentDate)

            /*
             // *** RANDOM DEBUG PROPERTIES ***
             self.reactionTime = Int.random(within: 150...750)
             self.reactionDate = Date.random(within: currentDate.startOfWeek()...currentDate.endOfWeek())
             self.reactionWeekday = Calendar.current.component(.weekday, from: reactionDate)
            */
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
