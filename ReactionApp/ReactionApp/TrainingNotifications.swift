//
//  TrainingNotifications.swift
//  ReactionApp
//
//  Created by Руслан on 27.02.17.
//  Copyright © 2017 Ruslan Timchenko. All rights reserved.
//

import Foundation
import RealmSwift

class TrainingNotifications: Object {
    private let backgroundQueue = DispatchQueue(label: "com.rstimchenko.backgroundQueue")
    
    dynamic var isSwitchOn = !(UIApplication.shared.currentUserNotificationSettings?.types == []) // default
    dynamic var hireDate = NotificationManager.shared.currentDate(withHour: 12, andMinute: 00) // default
    
    dynamic var isSwitchOnKey = "isSwitchOnKey"
    
    override open class func primaryKey() -> String? { return "isSwitchOnKey" }
    
    func save() {
        backgroundQueue.sync {
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(self, update: realm.objects(TrainingNotifications.self).first != nil ? true : false)
                }
            } catch let error as NSError {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func changeSwitchValue() {
        backgroundQueue.sync {
            do {
                let realm = try Realm()
                try realm.write {
                    self.isSwitchOn = !self.isSwitchOn
                    realm.add(self, update: realm.objects(TrainingNotifications.self).first != nil ? true : false)
                }
            } catch let error as NSError {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func changeHireDate(withDate date: Date) {
        backgroundQueue.sync {
            do {
                let realm = try Realm()
                try realm.write {
                    self.hireDate = date
                    realm.add(self, update: realm.objects(TrainingNotifications.self).first != nil ? true : false)
                }
            } catch let error as NSError {
                fatalError(error.localizedDescription)
            }
        }
    }

}
