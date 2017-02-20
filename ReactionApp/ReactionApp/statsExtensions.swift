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
    
    case day = 0, week, month, allTime
}

extension Date {
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month],
                                                                           from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1),
                                     to: self.startOfMonth())!
    }
    
    func startOfWeek() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.weekOfYear, .yearForWeekOfYear],
                                                                           from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfWeek() -> Date {
        return Calendar.current.date(byAdding: DateComponents.init(day: -1, weekOfYear: 1),
                                     to: self.startOfWeek())!
    }
}
