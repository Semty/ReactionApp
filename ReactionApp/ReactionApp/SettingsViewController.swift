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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        isNotificationsOn = UserDefaultManager.shared.loadValue(forKey: .kNotificationsOn) as? Bool != nil &&
                            !(UIApplication.shared.currentUserNotificationSettings?.types == []) ?
                            UserDefaultManager.shared.loadValue(forKey: .kNotificationsOn) as! Bool :
                            !(UIApplication.shared.currentUserNotificationSettings?.types == [])
        
        isNotificationsDisabled = UIApplication.shared.currentUserNotificationSettings?.types == []
        
        ringTime = UserDefaultManager.shared.loadValue(forKey: .kRingTime) as? Date ??
                   NotificationManager.shared.currentDate(withHour: 20, andMinute: 00)

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
