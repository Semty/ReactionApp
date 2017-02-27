//
//  SettingsViewController.swift
//  ReactionApp
//
//  Created by Руслан on 27.02.17.
//  Copyright © 2017 Ruslan Timchenko. All rights reserved.
//

import UIKit
import RealmSwift
import Eureka

class SettingsViewController: FormViewController {
    
    let notificationDisabledFooter = "Notifications disabled. You can activate it:\nSettings -> ReactionApp -> Push Notifications -> Allow Notifications"
    let isNotificationsDisabled = UIApplication.shared.currentUserNotificationSettings?.types == []
    
    var trainingNotifications = try! Realm().object(ofType: TrainingNotifications.self, forPrimaryKey: "isSwitchOnKey")
                                ?? TrainingNotifications()

    override func viewDidLoad() {
        super.viewDidLoad()

        form.inlineRowHideOptions = [.AnotherInlineRowIsShown, .FirstResponderChanges]
        
        form +++ Section(header: "Training Notifications",
                         footer: isNotificationsDisabled
                                 ? notificationDisabledFooter
                                 : "")
            
                    <<< SwitchRow("switchRowTag") {
                        
                        $0.disabled = Condition.function(["switchRowTag"], { form in
                            return self.isNotificationsDisabled
                        })
                        
                        $0.value = trainingNotifications.isSwitchOn
                        
                        $0.title = "Switch on/off"
                    }.onChange({ row in
                        self.trainingNotifications.changeSwitchValue()
                        if !row.value! {
                            NotificationManager.shared.cancelAllNotifications()
                        }
                    })
            
                    <<< TimeInlineRow() {
                        
                        $0.hidden = Condition.function(["switchRowTag"], { form in
                            return !((form.rowBy(tag: "switchRowTag") as? SwitchRow)?.value ?? false)
                        })
                        
                        $0.title = "Notification's time"
                        $0.value = trainingNotifications.hireDate
                    }.onChange({ row in
                        NotificationManager.shared.setUpLocalNotification(date: row.value!)
                        self.trainingNotifications.changeHireDate(withDate: row.value!)
// MARK: - Need change set up local notification
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
