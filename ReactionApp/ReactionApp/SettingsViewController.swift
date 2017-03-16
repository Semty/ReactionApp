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
    
// MARK: - Localizable Strings
    
    let notificationDisabledFooter =
        NSLocalizedString("notificationDisabledFooter",
                          tableName: "Settings", bundle: Bundle.main,
                          value: "Notifications disabled. You can activate it:\nSettings -> ReactionApp -> Push Notifications -> Allow Notifications",
                          comment: "Notifications Settings Footer")
    
    let trainingNotificationHeader =
        NSLocalizedString("trainingNotificationHeader",
                          tableName: "Settings",
                          bundle: Bundle.main,
                          value: "Training Notifications",
                          comment: "Training Settings Header")
    
    let trainingNotificationTitle =
        NSLocalizedString("trainingNotificationTitle",
                          tableName: "Settings",
                          bundle: Bundle.main,
                          value: "On/Off",
                          comment: "Training Settings Title")
    
    let trainingNotificationRingTime =
        NSLocalizedString("trainingNotificationRingTime",
                          tableName: "Settings",
                          bundle: Bundle.main,
                          value: "Time",
                          comment: "Notifications Settings Ring Time")
    
    let redCircleTimeHeader =
        NSLocalizedString("redCircleTimeHeader",
                          tableName: "Settings",
                          bundle: Bundle.main,
                          value: "Min and Max \"Red Circle Time\"",
                          comment: "Red Circle Time Header")
    
    let redCircleTimeMinTitle =
        NSLocalizedString("redCircleTimeMinTitle",
                          tableName: "Settings",
                          bundle: Bundle.main,
                          value: "Min",
                          comment: "Red Circle Time Min Title")
    
    let secLString =
        NSLocalizedString("sec", tableName: "Settings",
                          bundle: Bundle.main,
                          value: "sec", comment: "sec")
    
    let redCircleTimeMaxTitle =
        NSLocalizedString("redCircleTimeMaxTitle",
                          tableName: "Settings",
                          bundle: Bundle.main,
                          value: "Max",
                          comment: "Red Circle Time Max Title")
    
    let maxSavingTimeHeader =
        NSLocalizedString("maxSavingTimeHeader",
                          tableName: "Settings",
                          bundle: Bundle.main,
                          value: "Max Reaction Time for Save",
                          comment: "Max Saving Time Header")
    
    let maxSavingTimeTitle =
        NSLocalizedString("maxSavingTimeTitle",
                          tableName: "Settings",
                          bundle: Bundle.main,
                          value: "Reaction Time (in ms)",
                          comment: "Max Saving Time Title")
    
    let msLString = NSLocalizedString("ms", tableName: "Settings",
                                      bundle: Bundle.main,
                                      value: "ms", comment: "ms")
    
// MARK: - Variables
    
    var isNotificationsDisabled = Bool()
    var isNotificationsOn = Bool()
    var ringTime = Date()
    
    var minPreparationTime = Double()
    var maxPreparationTime = Double()
    
    var maxSavingTime = Int()
    
// MARK: - Functions

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

        
        form +++ Section(header: trainingNotificationHeader,
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
                        
                    $0.title = trainingNotificationTitle
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
                        
                    $0.title = trainingNotificationRingTime
                    $0.value = ringTime
                }.onChange({ row in
                    NotificationManager.shared.setUpLocalNotification(date: row.value!)
                    UserDefaultManager.shared.save(value: row.value!, forKey: .kRingTime)

                }).cellUpdate({ cell, row in
                    NotificationManager.shared.setUpLocalNotification(date: row.value!)
                })

        
        form +++ Section(header: redCircleTimeHeader,
                         footer: "")
        
                <<< PickerInlineRow<Double>() { (row : PickerInlineRow<Double>) -> Void in
                    row.title = redCircleTimeMinTitle
                    row.displayValueFor = { (rowValue: Double?) in
                        return rowValue.map { "\($0) \(self.secLString)" }
                    }
                    row.options = [1, 2, 3, 4]
                    row.value = minPreparationTime
                    
                }.onChange({ (row: PickerInlineRow<Double>) in
                    
                    UserDefaultManager.shared.save(value: row.value!, forKey: .kMinPreparationTime)
                    Circle.sharedCircle.preparationTimeFrom = row.value!
                })
        
                <<< PickerInlineRow<Double>() { (row : PickerInlineRow<Double>) -> Void in
                    row.title = redCircleTimeMaxTitle
                    row.displayValueFor = { (rowValue: Double?) in
                        return rowValue.map { "\($0) \(self.secLString)" }
                    }
                    row.options = [5, 6, 7, 8]
                    row.value = maxPreparationTime
                
                }.onChange({ (row: PickerInlineRow<Double>) in
                    
                    UserDefaultManager.shared.save(value: row.value!, forKey: .kMaxPreparationTime)
                    Circle.sharedCircle.preparationTimeUntil = row.value!
                })
        
        
        form +++ Section(header: maxSavingTimeHeader,
                         footer: "")
        
            <<< PickerInlineRow<Int>() { (row : PickerInlineRow<Int>) -> Void in
                row.title = maxSavingTimeTitle
                row.displayValueFor = { (rowValue: Int?) in
                    return rowValue.map { "\($0) \(self.msLString)" }
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
