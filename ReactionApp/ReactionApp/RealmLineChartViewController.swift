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
        
        switch self.dateStatsSegmentedControl.selectedSegmentIndex {
            
        case DateStats.day.rawValue:
            
            return xAxisValueForDayStats(withIndex: value)
            
        case DateStats.week.rawValue:
            
            return xAxisValueForWeekdayStats(withDayNumber: value)
        default:
            break
        }
        return ""
    }
}

// MARK: - RealmLineChartViewController

class RealmLineChartViewController: RealmDemoBaseViewController, ChartViewDelegate {
    
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var barChartView: BarChartView!
    
    
    @IBOutlet weak var dateStatsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var currentDateLabel: UILabel!
    
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    var currentDayResults: Results<ReactionResultObject>?
    var currentWeekResults: Results<ReactionResultObject>?
    
    var currentDate = Date()
    
    // MARK: - Private Variables
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        axisFormatDelegate = self
        
        chartView.delegate = self
        barChartView.delegate = self
        
        chartView.xAxis.valueFormatter = axisFormatDelegate
        barChartView.xAxis.valueFormatter = axisFormatDelegate
        
        self.setupBarLineChartView(chartView: chartView)
        self.setupBarLineChartView(chartView: barChartView)
        
        barChartView.leftAxis.axisMinimum = 0.0
        
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
        self.currentDayResults = try! Realm().objects(ReactionResultObject.self).filter("reactionDate >= %@ && reactionDate <= %@",
                                                                                        currentDate.startOfDay(), currentDate.endOfDay()).sorted(byProperty: "reactionDate", ascending: false)
        
        self.currentWeekResults = try! Realm().objects(ReactionResultObject.self).filter("reactionDate >= %@ && reactionDate <= %@",
                                                                                         currentDate.startOfWeek(), currentDate.endOfWeek())
    }
    
    func setDateInLabel(forPeriod period: DateStats) {
        
        switch period {
        case .day:
            
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "dd MMMM"
            
            self.currentDateLabel.text = dayFormatter.string(from: currentDate)
        case .week:
            
            let weekFormatter = DateFormatter()
            weekFormatter.dateFormat = "dd MMMM"
            
            self.currentDateLabel.text = "\(weekFormatter.string(from: currentDate.startOfWeek())) - \(weekFormatter.string(from: currentDate.endOfWeek()))"
        default:
            break
        }
        
    }
    
// MARK: - Data Initialization
    
    func setDayData() {
        
        self.setDateInLabel(forPeriod: .day)

        let animationDuration: TimeInterval = 1.2
        let resultsCount = (currentDayResults?.count)!
        var overallTime = 0
        
        if resultsCount > 0 {
            
            print("setDayData, OBJECTS = \(resultsCount)")
            
            var dataEntries: [ChartDataEntry] = []
            
            for (index, result) in (currentDayResults?.enumerated())! {
                
                let dataEntry = ChartDataEntry(x: Double(index), y: Double(result.reactionTime))
                overallTime += result.reactionTime
                
                dataEntries.append(dataEntry)
            }
            
            chartView.data = super.createReactionDayChartData(withDataEntries: dataEntries,
                                                              chartView: chartView, andrResultsCount: resultsCount)
            
            super.addLimitLine(with: overallTime, count: resultsCount, andChartView: chartView)
            
            self.chartView.animate(yAxisDuration: animationDuration, easingOption: .easeOutExpo)
            
        }
        
        UIView.animate(withDuration: 0.3) {
            self.chartView.alpha = 1
            self.barChartView.alpha = 0.0
        }
        
    }
    
    func setWeekData() {
        
        self.setDateInLabel(forPeriod: .week)
        
        let animationDuration: TimeInterval = 1.2
        let resultCount = (currentWeekResults?.count)!
        
        if resultCount > 0 {
            
            print("setWeekData, OBJECTS = \(resultCount)")
            
            var dataEntries: [BarChartDataEntry] = []
            
            for index in 1...7 {
                
                let avgValue: Int = currentWeekResults!.filter("reactionWeekday == %@", index).average(ofProperty: "reactionTime") ?? 0
                
                let dataEntry = BarChartDataEntry(x: Double(index - 1), y: Double(avgValue))
                dataEntries.append(dataEntry)
            }
            
            if let data = super.createReactionWeekChartData(withDataEntries: dataEntries,
                                                            chartView: barChartView, andrResultsCount: resultCount) {
                barChartView.data = data
            }
            
            //addLimitLine(with: overallTime, and: results.count)
            
            self.barChartView.animate(yAxisDuration: animationDuration, easingOption: .easeOutBounce)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.barChartView.alpha = 1
            self.chartView.alpha = 0.0
        }
    }
    
// MARK: - Actions
    
    @IBAction func actionDateStatsChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case DateStats.day.rawValue:
            setDayData()
        case DateStats.week.rawValue:
            setWeekData()
        default:
            break
        }
        
    }
    
}










