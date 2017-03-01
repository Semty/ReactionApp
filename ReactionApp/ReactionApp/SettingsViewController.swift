//
//  SettingsViewController.swift
//  ReactionApp
//
//  Created by Руслан on 27.02.17.
//  Copyright © 2017 Ruslan Timchenko. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
import Eureka

class SettingsViewController: FormViewController {
    
    let notificationDisabledFooter = "Notifications disabled. You can activate it:\nSettings -> ReactionApp -> Push Notifications -> Allow Notifications"
    
    var isNotificationsDisabled = Bool()
    var isNotificationsOn = Bool()
    var ringTime = Date()
    
    var minPreparationTime = Double()
    var maxPreparationTime = Double()
    
    var maxSavingTime = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        isNotificationsOn = UIApplication.shared.currentUserNotificationSettings?.types == [] ? false
                            : UserDefaultManager.shared.loadValue(forKey: .kNotificationsOn) as? Bool ?? true
        
        isNotificationsDisabled = UIApplication.shared.currentUserNotificationSettings?.types == []
        
        ringTime = UserDefaultManager.shared.loadValue(forKey: .kRingTime) as? Date ??
                   NotificationManager.shared.currentDate(withHour: 20, andMinute: 00)
        
        minPreparationTime = UserDefaultManager.shared.loadValue(forKey: .kMinPreparationTime) as? Double ?? 2.0
        maxPreparationTime = UserDefaultManager.shared.loadValue(forKey: .kMaxPreparationTime) as? Double ?? 8.0
        
        maxSavingTime = UserDefaultManager.shared.loadValue(forKey: .kMaxSavingTime) as? Int ?? 1000

        form.inlineRowHideOptions = [.AnotherInlineRowIsShown, .FirstResponderChanges]

        
        form +++ Section(header: "Training Notifications",
                         footer: isNotificationsDisabled
                                 ? notificationDisabledFooter
                                 : "")
            
                <<< SwitchRow("switchRowTag") {
                        
                    $0.disabled = Condition.function(["switchRowTag"], { form in
                        return self.isNotificationsDisabled
                    })
                        
                    $0.cellSetup({ (cell, row) in
                        cell.switchControl?.onTintColor = FlatSkyBlueDark()
                    })
                        
                    $0.value = isNotificationsOn
                        
                    $0.title = "Switch on/off"
                }.onChange({ row in
                    UserDefaultManager.shared.save(value: !self.isNotificationsOn, forKey: .kNotificationsOn)
                    if !row.value! {
                        NotificationManager.shared.cancelAllNotifications()
                    }
                })
            
                <<< TimeInlineRow() {
                        
                    $0.hidden = Condition.function(["switchRowTag"], { form in
                        return !((form.rowBy(tag: "switchRowTag") as? SwitchRow)?.value ?? false)
                    })
                        
                    $0.title = "Notification's time"
                    $0.value = ringTime
                }.onChange({ row in
                    NotificationManager.shared.setUpLocalNotification(date: row.value!)
                    UserDefaultManager.shared.save(value: row.value!, forKey: .kRingTime)

                }).cellUpdate({ cell, row in
                    NotificationManager.shared.setUpLocalNotification(date: row.value!)
                })

        
        form +++ Section(header: "Change Min and Max \"Red Circle Time\"", footer: "")
        
                <<< PickerInlineRow<Double>() { (row : PickerInlineRow<Double>) -> Void in
                    row.title = "Min"
                    row.displayValueFor = { (rowValue: Double?) in
                        return rowValue.map { "\($0) sec" }
                    }
                    row.options = [1, 2, 3, 4]
                    row.value = minPreparationTime
                    
                }.onChange({ (row: PickerInlineRow<Double>) in
                    
                    UserDefaultManager.shared.save(value: row.value!, forKey: .kMinPreparationTime)
                    Circle.sharedCircle.preparationTimeFrom = row.value!
                })
        
                <<< PickerInlineRow<Double>() { (row : PickerInlineRow<Double>) -> Void in
                    row.title = "Max"
                    row.displayValueFor = { (rowValue: Double?) in
                        return rowValue.map { "\($0) sec" }
                    }
                    row.options = [5, 6, 7, 8]
                    row.value = maxPreparationTime
                
                }.onChange({ (row: PickerInlineRow<Double>) in
                    
                    UserDefaultManager.shared.save(value: row.value!, forKey: .kMaxPreparationTime)
                    Circle.sharedCircle.preparationTimeUntil = row.value!
                })
        
        
        form +++ Section(header: "Change max Reaction Time for Save", footer: "")
        
            <<< PickerInlineRow<Int>() { (row : PickerInlineRow<Int>) -> Void in
                row.title = "Reaction Time (in ms)"
                row.displayValueFor = { (rowValue: Int?) in
                    return rowValue.map { "\($0) ms" }
                }
                row.options = [400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000]
                row.value = maxSavingTime
                
            }.onChange({ (row: PickerInlineRow<Int>) in
                    
                    UserDefaultManager.shared.save(value: row.value!, forKey: .kMaxSavingTime)
                    Circle.sharedCircle.maxSavingTime = row.value!
            })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
