//
//  DateValueFormatter.swift
//  ReactionApp
//
//  Created by Руслан on 23.02.17.
//  Copyright © 2017 Ruslan Timchenko. All rights reserved.
//

import UIKit
import Charts

class DayAxisValueFormatter: NSObject, IAxisValueFormatter {
    
    let months: [String]
    weak var chart: BarLineChartViewBase?
    
    init(forChart chart: BarLineChartViewBase) {
        
        self.chart = chart
        
        self.months = ["Jan", "Feb", "Mar",
                       "Apr", "May", "Jun",
                       "Jul", "Aug", "Sep",
                       "Oct", "Nov", "Dec"]
    }
    
    func stringForValue(_ value: Double,
                        axis: AxisBase?) -> String {
        
        let days = Int(value.rounded())
        let year = determineYear(forDays: days)
        let month = determineMonth(forDayOfYear: days)
        
        let monthName = months[month % months.count]
        let yearName = "\(year - 2000)"
        
        if (chart?.visibleXRange)! > 30 * 3 {
            
            return "\(monthName) \(yearName)"
        } else {
            
            let dayOfMonth = determineDayOfMonth(forDays: days, month: month + 12 * (year - 2017))
            
            var appendix = "th"
            
            switch dayOfMonth {
            case 1:
                appendix = "st"
            case 2:
                appendix = "nd"
            case 3:
                appendix = "rd"
            case 21:
                appendix = "st"
            case 22:
                appendix = "nd"
            case 23:
                appendix = "rd"
            case 31:
                appendix = "st"
            default:
                break
            }
            
            return dayOfMonth == 0 ? "" : "\(dayOfMonth)\(appendix) \(monthName)"
        }
    }
    
    func days(forMonth month: Int, year: Int) -> Int {
        
        // month is 0-based
        
        if month == 1 {
            var is29Feb = false
            
            if year < 1582 {
                is29Feb = (year < 1 ? year + 1 : year) % 4 == 0
            } else if year > 1582 {
                is29Feb = year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)
            }
            
            return is29Feb ? 29 : 28
        }
        
        if month == 3 || month == 5 || month == 8 || month == 10 {
            return 30
        }
        
        return 31
    }
    
    func determineMonth(forDayOfYear dayOfYear: Int) -> Int {
        
        var month = -1
        var days = 0
        
        while days < dayOfYear {
            
            month += 1
            
            if month >= 12 {
                month = 0
            }
            
            let year = determineYear(forDays: days)
            days += self.days(forMonth: month, year: year)
            
        }
        
        return max(month, 0)
    }
    
    func determineDayOfMonth(forDays days: Int, month: Int) -> Int {
        
        var count = 0
        var daysForMonths = 0
        
        while count < month {
            
            let year = determineYear(forDays: daysForMonths)
            daysForMonths += self.days(forMonth: count % 12, year: year)
            count += 1
        }
        
        return days - daysForMonths
    }
    
    func determineYear(forDays days: Int) -> Int {
        
        switch days {
            
        case 0...365:
            return 2017
            
        case 366...730:
            return 2018
            
        case 731...1095:
            return 2019
            
        case 1096...1461:
            return 2020
            
        default:
            return 2021
        }
    }
}








