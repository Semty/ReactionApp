//
//  RealmLineChartViewController.swift
//  ReactionApp
//
//  Created by Руслан on 18.02.17.
//  Copyright © 2017 Ruslan Timchenko. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
import Charts

// MARK: - axisFormatDelegate

extension RealmLineChartViewController: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {

        return xAxisValueForDayStats(withIndex: value)
    }
}

// MARK: - RealmLineChartViewController

class RealmLineChartViewController: RealmDemoBaseViewController, ChartViewDelegate {
    
    @IBOutlet weak var dayChartView: LineChartView!
    @IBOutlet weak var weekChartView: BarChartView!
    @IBOutlet weak var allTimeChartView: BarChartView!
    
    
    @IBOutlet weak var dateStatsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var currentDateLabel: UILabel!
    
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    var currentDayResults:  Results<ReactionResultObject>?
    var currentWeekResults: Results<ReactionResultObject>?
    var allTimeResults:     Results<ReactionResultObject>?
    
    var currentDate = Date()
    
    // MARK: - Private Variables
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        axisFormatDelegate = self
        
        dayChartView.delegate = self
        weekChartView.delegate = self
        allTimeChartView.delegate = self
        
        dayChartView.xAxis.valueFormatter = axisFormatDelegate
        
        weekChartView.xAxis.valueFormatter = DayAxisValueFormatter(forChart: weekChartView)
        allTimeChartView.xAxis.valueFormatter = DayAxisValueFormatter(forChart: allTimeChartView)
        
        self.setupBarLineChartView(chartView: dayChartView)
        self.setupBarLineChartView(chartView: weekChartView)
        self.setupBarLineChartView(chartView: allTimeChartView)
        
        weekChartView.leftAxis.axisMinimum = 0.0
        
        allTimeChartView.maxVisibleCount = 25
        allTimeChartView.leftAxis.axisMinimum = 0.0
        
        self.setRealmQueries()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let date = Date(timeIntervalSinceNow: 0)
        currentDate = date
        
        switch dateStatsSegmentedControl.selectedSegmentIndex {
        case DateStats.day.rawValue:
            self.setDayData()
        case DateStats.week.rawValue:
            self.setWeekData()
        case DateStats.allTime.rawValue:
            setAllTimeData()
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helpful Functions
    
    func xAxisValueForDayStats(withIndex index: Double) -> String {
        if (Int)(index) < (currentDayResults?.count)! {
            
            let date = currentDayResults?[(Int)(index)].reactionDate
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"

            return dateFormatter.string(from: date!)
        }
        return ""
    }
    
    func setRealmQueries() {
        self.currentDayResults = try! Realm().objects(
            ReactionResultObject.self).filter(
            "reactionDate >= %@ && reactionDate <= %@",
            currentDate.startOfDay(), currentDate.endOfDay())
        
        self.currentWeekResults = try! Realm().objects(
            ReactionResultObject.self).filter(
            "reactionDate <= %@ && reactionDate >= %@",
            currentDate.endOfDay(), Date(timeInterval: -518_400, since: currentDate.startOfDay()))
        
        self.allTimeResults = try! Realm().objects(ReactionResultObject.self)
    }
    
    func setDateInLabel(forPeriod period: DateStats) {
        
        switch period {
        case .day:
            
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "dd MMMM"
            dayFormatter.locale = Locale(identifier: Language.currentAppleLanguageFull())
            
            self.currentDateLabel.text = dayFormatter.string(from: currentDate)
        case .week:
            
            let weekFormatter = DateFormatter()
            weekFormatter.dateFormat = "dd MMMM"
            weekFormatter.locale = Locale(identifier: Language.currentAppleLanguageFull())
            
            self.currentDateLabel.text = "\(weekFormatter.string(from: Date(timeInterval: -518_400, since: currentDate.startOfDay()))) - \(weekFormatter.string(from: currentDate.endOfDay()))"
        case .allTime:
            
            let allTimeFormatter = DateFormatter()
            allTimeFormatter.dateFormat = "dd MMM yyy"
            allTimeFormatter.locale = Locale(identifier: Language.currentAppleLanguageFull())
            
            self.currentDateLabel.text = "\(allTimeFormatter.string(from: (allTimeResults?.min(ofProperty: "reactionDate")) ?? Date(timeInterval: -518_400, since: currentDate.startOfDay()))) - " +
                                         "\(allTimeFormatter.string(from: (allTimeResults?.max(ofProperty: "reactionDate")) ?? currentDate.endOfDay()))"
        }
        
    }
    
// MARK: - Data Initialization
    
    func setDayData() {
        
        self.setDateInLabel(forPeriod: .day)

        let animationDuration: TimeInterval = 1.2
        let resultsCount = (currentDayResults?.count)!
        var lastXAxisIndex = 0.0
        var overallTime = 0
        
        if resultsCount > 0 {
            
            print("setDayData, OBJECTS = \(resultsCount)")
            
            var dataEntries: [ChartDataEntry] = []
            
            for (index, result) in (currentDayResults?.enumerated())! {
                
                let dataEntry = ChartDataEntry(x: Double(index), y: Double(result.reactionTime))
                overallTime += result.reactionTime
                
                dataEntries.append(dataEntry)
                
                if index + 1 == resultsCount {
                    lastXAxisIndex = Double(index)
                }
            }
            
            dayChartView.data = super.createReactionDayChartData(withDataEntries: dataEntries,
                                                              chartView: dayChartView, andrResultsCount: resultsCount)
            
            super.addLimitLine(with: overallTime, count: resultsCount, andChartView: dayChartView)
            
            dayChartView.setVisibleXRangeMaximum(20.0)
            dayChartView.moveViewToX(lastXAxisIndex)
            
            self.dayChartView.animate(yAxisDuration: animationDuration, easingOption: .easeOutExpo)
            
        }
        
        UIView.animate(withDuration: 0.3) {
            self.dayChartView.alpha = 1
            self.weekChartView.alpha = 0.0
            self.allTimeChartView.alpha = 0.0
        }
        
    }
    
    func setWeekData() {
        
        self.setDateInLabel(forPeriod: .week)
        
        let animationDuration: TimeInterval = 1.2
        var overallTime = 0
        var overallCount = 0
        let resultCount = (currentWeekResults?.count)!
        
        if resultCount > 0 {
            
            print("setWeekData, OBJECTS = \(resultCount)")
            
            var dataEntries: [BarChartDataEntry] = []
            let minDayOfYear: Int = (Calendar.current.ordinality(of: .day, in: .year, for: currentDate))! - 6
            let maxDayOfYear: Int = (Calendar.current.ordinality(of: .day, in: .year, for: currentDate))!
            
            for index in minDayOfYear...maxDayOfYear {
                
                let avgValue: Int = currentWeekResults!.filter("reactionDayOfYear == %@", index).average(ofProperty: "reactionTime") ?? 0
                overallTime += avgValue
                overallCount += avgValue != 0 ? 1 : 0
                
                let dataEntry = BarChartDataEntry(x: Double(index), y: Double(avgValue))
                dataEntries.append(dataEntry)
            }

            weekChartView.data = super.createReactionWeekChartData(withDataEntries: dataEntries,
                                                                   chartView: weekChartView)
            
            self.weekChartView.animate(yAxisDuration: animationDuration, easingOption: .easeOutQuint)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.weekChartView.alpha = 1
            self.dayChartView.alpha = 0.0
            self.allTimeChartView.alpha = 0.0
        }
    }
    
    func setAllTimeData() {
        
        self.setDateInLabel(forPeriod: .allTime)
        
        let animationDuration: TimeInterval = 1.2
        var overallTime = 0
        var lastXAxisIndex = 0.0
        var overallCount = 0
        let resultCount = (allTimeResults?.count)!
        
        if resultCount > 0 {
            
            print("setAllTimeData, OBJECTS = \(resultCount)")
            
            var dataEntries: [BarChartDataEntry] = []
            let minDayOfYear: Int = (allTimeResults?.min(ofProperty: "reactionDayOfYear"))!
            let maxDayOfYear: Int = (allTimeResults?.max(ofProperty: "reactionDayOfYear"))!
            
            for index in minDayOfYear...maxDayOfYear {
                
                let avgValue: Int = allTimeResults!.filter("reactionDayOfYear == %@", index).average(ofProperty: "reactionTime") ?? 0
                overallTime += avgValue
                overallCount += avgValue != 0 ? 1 : 0
                
                let dataEntry = BarChartDataEntry(x: Double(index), y: Double(avgValue))
                dataEntries.append(dataEntry)
                
                if index == maxDayOfYear {
                    lastXAxisIndex = Double(index)
                }
            }
            
            allTimeChartView.data = super.createReactionAllTimeChartData(withDataEntries: dataEntries,
                                                                      chartView: allTimeChartView)
            
            allTimeChartView.moveViewToX(lastXAxisIndex)
            dayChartView.setVisibleXRangeMaximum(60.0)
            
            self.allTimeChartView.animate(yAxisDuration: animationDuration, easingOption: .easeOutQuint)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.allTimeChartView.alpha = 1
            self.weekChartView.alpha = 0.0
            self.dayChartView.alpha = 0.0
        }
    }
    
// MARK: - Actions
    
    @IBAction func actionDateStatsChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case DateStats.day.rawValue:
            setDayData()
        case DateStats.week.rawValue:
            setWeekData()
        case DateStats.allTime.rawValue:
            setAllTimeData()
        default:
            break
        }
        
    }
    
}
