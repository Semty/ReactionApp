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
    dynamic var reactionDayOfYear   = 0
    
    func save() {
        backgroundQueue.sync {
            
            let currentDate = Date.init(timeIntervalSinceNow: 0)
            
            self.reactionDate = currentDate
            self.reactionWeekday = Calendar.current.component(.weekday, from: currentDate)
            self.reactionDayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: currentDate)!
            
            /*
             let formatter = DateFormatter()
             formatter.dateFormat = "dd MMMM yyyy"
             
             // *** RANDOM DEBUG PROPERTIES ***
             self.reactionTime = Int.random(within: 150...750)
             // 1 January // 31 December
             self.reactionDate = Date.random(within: currentDate...Date.init(timeInterval: 30_000_000, since: currentDate))
             */
            
            let currentYear = Calendar.current.component(.year, from: self.reactionDate)
            let multiplier =  currentYear != 2021 ? (currentYear - 2017) * 365 : (currentYear - 2017) * 365 + 1
            self.reactionDayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: reactionDate)! + multiplier
            
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
