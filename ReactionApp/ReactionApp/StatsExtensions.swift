//
//  statsExtensions.swift
//  ReactionApp
//
//  Created by Руслан on 19.02.17.
//  Copyright © 2017 Ruslan Timchenko. All rights reserved.
//

import Foundation
import RealmSwift
import Charts

enum DateStats: Int {
    
    case day = 0, week, allTime
}

extension Calendar {
    
    static var sharedCurrent: Calendar {
        
        switch Language.currentAppleLanguage() {
        case "ja":
            var calendar = Calendar(identifier: .japanese)
            calendar.locale = Locale(identifier: Language.currentAppleLanguageFull())
            return calendar
        default:
            var calendar = Calendar(identifier: .gregorian)
            calendar.locale = Locale(identifier: Language.currentAppleLanguageFull())
            return calendar
        }
    }
}

extension Array where Element: Integer {
    
    var total: Element {
        return reduce(0, +)
    }
}

extension Collection where Iterator.Element == Int, Index == Int {
    
    var average: Double {
        return isEmpty ? 0 : Double(reduce(0, +)) / Double(endIndex-startIndex)
    }
}

extension Array where Element: FloatingPoint {
    
    var total: Element {
        return reduce(0, +)
    }
    
    var average: Element {
        return isEmpty ? 0 : total / Element(count)
    }
}

extension Date {
    
    func startOfDay() -> Date {
        return Calendar.sharedCurrent.date(from:
            Calendar.sharedCurrent.dateComponents([.year, .month, .weekOfMonth, .day, .hour, .minute, .second],
                                                                           from: Calendar.sharedCurrent.startOfDay(for: self)))!
    }
    
    func endOfDay() -> Date {
        return Calendar.sharedCurrent.date(byAdding: DateComponents.init(day: 1, second: -1),
                                     to: self.startOfDay())!
    }
    
    func startOfMonth() -> Date {
        return Calendar.sharedCurrent.date(from: Calendar.sharedCurrent.dateComponents([.year, .month],
                                                                           from: Calendar.sharedCurrent.startOfDay(for: self)))!
        
    }
    
    func endOfMonth() -> Date {
        return Calendar.sharedCurrent.date(byAdding: DateComponents(month: 1, second: -1),
                                     to: self.startOfMonth())!
    }
    
    func startOfWeek() -> Date {
        return Calendar.sharedCurrent.date(from: Calendar.sharedCurrent.dateComponents([.weekOfYear, .yearForWeekOfYear],
                                                                           from: Calendar.sharedCurrent.startOfDay(for: self)))!
    }
    
    func endOfWeek() -> Date {
        return Calendar.sharedCurrent.date(byAdding: DateComponents.init(second: -1, weekOfYear: 1),
                                     to: self.startOfWeek())!
    }
}
