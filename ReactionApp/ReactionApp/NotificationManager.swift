//
//  notificationManager.swift
//  ReactionApp
//
//  Created by Руслан on 27.02.17.
//  Copyright © 2017 Ruslan Timchenko. All rights reserved.
//

import UIKit

class NotificationManager {
    
// MARK: - Localizable Strings
    
    var alertBodyLString =
        NSLocalizedString("alertBodyLString", tableName: "Notification",
                          bundle: Bundle.main,
                          value: "It is Time to Train Your Reaction!",
                          comment: "Notification Alert Body")
    
// MARK: - NotificationManager
    
    static let shared = NotificationManager()
    
    func setUpLocalNotification(date: Date) {
        
        let hour = Calendar.current.component(.hour, from: date)
        let minute = Calendar.current.component(.minute, from: date)

        let dateFire = currentDate(withHour: hour, andMinute: minute)
        
        print("DATE FIRE = ", dateFire)
        
        let localNotification = UILocalNotification()
        localNotification.fireDate = dateFire
        localNotification.alertBody = alertBodyLString
        localNotification.alertTitle = dateToHourString(dateFire)
        localNotification.repeatInterval = NSCalendar.Unit.day
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        
        cancelAllNotifications()
        UIApplication.shared.scheduleLocalNotification(localNotification);
    }
    
    func cancelAllNotifications() {
        UIApplication.shared.cancelAllLocalNotifications()
    }
    
    func currentDate(withHour hour: Int, andMinute minute: Int) -> Date {
        let calendar = Calendar.current;
        
        var dateFire = Date()
        
        // if today's date is passed, use tomorrow
        var fireComponents = calendar.dateComponents( [.day, .month, .year, .hour, .minute], from:dateFire)
        
        if (fireComponents.hour! > hour
            || (fireComponents.hour == hour && fireComponents.minute! >= minute) ) {
            
            dateFire = dateFire.addingTimeInterval(86400)  // Use tomorrow's date
            fireComponents = calendar.dateComponents( [.day, .month,
                                                       .year, .hour,
                                                       .minute],
                                                      from:dateFire);
        }
        
        // set up the time
        fireComponents.hour = hour
        fireComponents.minute = minute
        
        // schedule local notification
        dateFire = calendar.date(from: fireComponents)!
        
        return dateFire
    }
    
    private func dateToHourString(_ date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        
        return formatter.string(from: date)
    }
}




