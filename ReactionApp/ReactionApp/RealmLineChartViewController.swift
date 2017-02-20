//
//  RealmLineChartViewController.swift
//  ReactionApp
//
//  Created by Руслан on 18.02.17.
//  Copyright © 2017 Ruslan Timchenko. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import ChameleonFramework
import Charts

extension RealmLineChartViewController: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        switch self.dateStatsSegmentedControl.selectedSegmentIndex {
            
        case DateStats.day.rawValue:
            
            if (Int)(value) < currentResults.count {
                
                let date = currentResults[(Int)(value)].reactionDateSince1970
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                return dateFormatter.string(from: Date(timeIntervalSince1970: date))
            } else {
                return ""
            }
        
        case DateStats.week.rawValue:
            
            return weekDayString(forDayNumber: value)
        default:
            break
        }
        return ""
    }
}

class RealmLineChartViewController: RealmDemoBaseViewController, ChartViewDelegate {

    @IBOutlet weak var chartView: LineChartView!
    var barChartView = BarChartView()
    
    @IBOutlet weak var dateStatsSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var currentDateLabel: UILabel!
    
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    var isPresented = false
    
    var currentResults: [ReactionResultObject] = []
    
    var dayToday    = 0
    var weekDay     = 0
    var weekOfYear  = 0
    var monthToday  = 0
    
    let realm = try! Realm()
    
// MARK: - Private Variables
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.allButUpsideDown]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.barChartView = BarChartView(frame: self.chartView.frame)
        self.view.addSubview(barChartView)
        
        axisFormatDelegate = self
        chartView.delegate = self
        barChartView.delegate = self
        
        self.setupBarLineChartView(chartView: chartView)
        self.setupBarLineChartView(chartView: barChartView)
        
        // enable description text
        chartView.chartDescription?.enabled = false
        
        chartView.leftAxis.axisMaximum = 1000
        chartView.leftAxis.axisMinimum = 0
        
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.valueFormatter = axisFormatDelegate
        
        barChartView.xAxis.valueFormatter = axisFormatDelegate
        
        addMarker(forChartView: chartView)
        addMarker(forChartView: barChartView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.isPresented = true
        
        let date = Date(timeIntervalSinceNow: 0)
        
        self.dayToday   = self.getCurrentDateInfo(unit: .day, from: date)
        self.weekDay    = self.getCurrentDateInfo(unit: .weekday, from: date)
        self.weekOfYear = self.getCurrentDateInfo(unit: .weekOfYear, from: date)
        self.monthToday = self.getCurrentDateInfo(unit: .month, from: date)
        
        switch dateStatsSegmentedControl.selectedSegmentIndex {
        case DateStats.day.rawValue:
            self.setDayData()
        case DateStats.week.rawValue:
            self.setWeekData()
        default:
            break
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        self.isPresented = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// MARK: - Helpful Functions
    
    func weekDayString(forDayNumber number: Double) -> String {
        
        switch number {
        case 0:
            return "Sunday"
        case 1:
            return "Monday"
        case 2:
            return "Tuesday"
        case 3:
            return "Thursday"
        case 4:
            return "Wednesday"
        case 5:
            return "Friday"
        case 6:
            return "Saturday"
        default:
            return ""
        }
        
    }
    
    func addMarker(forChartView chartView: BarLineChartViewBase) {
        
        let marker = BalloonMarker.init(color: FlatGray(),
                                        font: UIFont.systemFont(ofSize: 12),
                                        textColor: FlatWhite(),
                                        insets: UIEdgeInsetsMake(8, 8, 20, 8))
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        chartView.marker = marker
    }
    
    func getCurrentDateInfo(unit: Calendar.Component, from date: Date) -> Int {
        return Calendar.current.component(unit, from: date)
    }
    
    func getReactionResultsFromDatabaseForDay() -> [ReactionResultObject] {
        
        let results = realm.objects(ReactionResultObject.self)
        
        switch dateStatsSegmentedControl.selectedSegmentIndex {
        case DateStats.day.rawValue:
            
            var currentDaysResults = [ReactionResultObject]()
            
            for result in results {
                
                if self.dayToday == self.getCurrentDateInfo(unit: .day,
                                                            from: Date.init(timeIntervalSince1970: result.reactionDateSince1970)) {
                    currentDaysResults.append(result)
                }
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM, dd"
            
            self.currentDateLabel.text = formatter.string(from: Date.init(timeIntervalSinceNow: 0))
            
            return currentDaysResults
        case DateStats.week.rawValue:
            
            var currentWeekResults = [ReactionResultObject]()
            
            for result in results {
                
                if self.weekOfYear == self.getCurrentDateInfo(unit: .weekOfYear,
                                                              from: Date.init(timeIntervalSince1970: result.reactionDateSince1970)) {
                    currentWeekResults.append(result)
                }
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM, dd"
            
            let date = Date(timeIntervalSinceNow: 0)
            
            let startDateWeek   = date.startOfWeek()
            let endDateWeek     = date.endOfWeek()
            
            self.currentDateLabel.text = "\(formatter.string(from: startDateWeek)) - \(formatter.string(from: endDateWeek))"
            
            return currentWeekResults
        case DateStats.month.rawValue:
            
            var currentMonthResults = [ReactionResultObject]()
            
            for result in results {
                
                if self.monthToday == self.getCurrentDateInfo(unit: .month,
                                                              from: Date.init(timeIntervalSince1970: result.reactionDateSince1970)) {
                    currentMonthResults.append(result)
                }
            }
            return currentMonthResults
        default:
            return [ReactionResultObject]()
        }
    }
    
    /*
    func addLimitLine(with overallTime: Int, and count: Int) {
        
        chartView.leftAxis.removeAllLimitLines()
        
        let limitTime = (Double)(overallTime) / (Double)(count)
        let limitLine = ChartLimitLine(limit: limitTime)
        limitLine.lineColor = FlatBlue()

        limitLine.lineDashLengths = [8.0]
        
        chartView.leftAxis.addLimitLine(limitLine)
    }
     */
    
    func maxAxisFrom(results: [ReactionResultObject], forChartView chartView: BarLineChartViewBase) {
        
        var baseAxis = Int.min
        
        for index in 0..<results.count {
            
            let reaction = results[index]
            
            if reaction.reactionTime > baseAxis {
                baseAxis = reaction.reactionTime
            }
        }
        
        if baseAxis + 50 < 1000 {
            chartView.leftAxis.axisMaximum = Double(baseAxis + 50)
        } else {
            chartView.leftAxis.axisMaximum = 1000
        }
    }
    
    func minAxisFrom(results: [ReactionResultObject], forChartView chartView: BarLineChartViewBase) {
        
        var baseAxis = Int.max
        
        for index in 0..<results.count {
            
            let reaction = results[index]
            
            if reaction.reactionTime < baseAxis {
                baseAxis = reaction.reactionTime
            }
        }
        
        if baseAxis - 50 > 0 {
            chartView.leftAxis.axisMinimum = Double(baseAxis - 50)
        } else {
            chartView.leftAxis.axisMinimum = 0
        }
    }
 
// MARK: - Data Initialization
    
    func setDayData() {
        
        chartView.isHidden = false
        barChartView.isHidden = true
        
        let results = self.getReactionResultsFromDatabaseForDay()
        var overallTime = 0
        
        if results.count > 0 {
            
            self.currentResults = results
            
            maxAxisFrom(results: results, forChartView: self.chartView)
            minAxisFrom(results: results, forChartView: self.chartView)
            
            var dataEntries: [ChartDataEntry] = []
            
            for num in 0..<results.count {
                
                let result = results[num]
                
                let dataEntry = ChartDataEntry(x: Double(num), y: Double(result.reactionTime))
                overallTime += result.reactionTime
                
                dataEntries.append(dataEntry)
            }
            
            let chartDataSet = LineChartDataSet(values: dataEntries,
                                                label: "Reaction Time")
            
            
            chartDataSet.drawCirclesEnabled = false
            
            chartDataSet.mode = .horizontalBezier
            chartDataSet.drawValuesEnabled = false
            
            chartDataSet.setColor(FlatSkyBlue())
            chartDataSet.drawFilledEnabled = true
            
            chartDataSet.lineWidth = 2
            
            let dataSets = [chartDataSet]
            
            let data = LineChartData.init(dataSets: dataSets)
            self.styleData(data: data)
            
            chartView.data = data
            
            //addLimitLine(with: overallTime, and: results.count)
            
            chartView.animate(yAxisDuration: 2, easingOption: .easeOutExpo)
        }
    }
    
    func setWeekData() {
        
        chartView.isHidden = true
        barChartView.isHidden = false
        
        let results = self.getReactionResultsFromDatabaseForDay()
        
        if results.count > 0 {
            
            self.currentResults = results
            
            var dataEntries: [BarChartDataEntry] = []
            
            var sundayOverall     = 0
            var mondayOverall     = 0
            var tuesdayOverall    = 0
            var wednesdayOverall  = 0
            var thursdayOverall   = 0
            var fridayOverall     = 0
            var saturdayOverall   = 0
            
            var sundayCount     = 0
            var mondayCount     = 0
            var tuesdayCount    = 0
            var wednesdayCount  = 0
            var thursdayCount   = 0
            var fridayCount     = 0
            var saturdayCount   = 0
            
            var overallTime = 0
            
            for num in 0..<results.count {
                
                let result = results[num]
                overallTime += result.reactionTime
                
                let weekday = getCurrentDateInfo(unit: .weekday, from: Date(timeIntervalSince1970: result.reactionDateSince1970))
                
                switch weekday {
                case 1:
                    sundayOverall += result.reactionTime
                    sundayCount += 1
                case 2:
                    mondayOverall += result.reactionTime
                    mondayCount += 1
                case 3:
                    tuesdayOverall += result.reactionTime
                    tuesdayCount += 1
                case 4:
                    wednesdayOverall += result.reactionTime
                    wednesdayCount += 1
                case 5:
                    thursdayOverall += result.reactionTime
                    thursdayCount += 1
                case 6:
                    fridayOverall += result.reactionTime
                    fridayCount += 1
                case 7:
                    saturdayOverall += result.reactionTime
                    saturdayCount += 1
                default:
                    break
                }
            }
            
            barChartView.leftAxis.axisMaximum = (Double)(overallTime) / (Double)(results.count) + 50.0
            barChartView.leftAxis.axisMinimum = 0
            
            for index in 0..<7 {
                
                switch index {
                case 0:
                    
                    var y = 0.1
                    
                    if sundayCount != 0 {
                        y = (Double)(sundayOverall) / (Double)(sundayCount)
                        y.round()
                    }
                    
                    let dataEntry = BarChartDataEntry(x: Double(index),
                                                      y: y)
                    
                    dataEntries.append(dataEntry)
                case 1:
                    
                    var y = 0.1
                    
                    if mondayCount != 0 {
                        y = (Double)(mondayOverall) / (Double)(mondayCount)
                        y.round()
                    }
                    
                    let dataEntry = BarChartDataEntry(x: Double(index),
                                                      y: y)
                    
                    dataEntries.append(dataEntry)
                case 2:
                    
                    var y = 0.1
                    
                    if tuesdayCount != 0 {
                        y = (Double)(tuesdayOverall) / (Double)(tuesdayCount)
                        y.round()
                    }
                    
                    let dataEntry = BarChartDataEntry(x: Double(index),
                                                      y: y)
                    
                    dataEntries.append(dataEntry)
                case 3:
                    
                    var y = 0.1
                    
                    if wednesdayCount != 0 {
                        y = (Double)(wednesdayOverall) / (Double)(wednesdayCount)
                        y.round()
                    }
                    
                    let dataEntry = BarChartDataEntry(x: Double(index),
                                                      y: y)
                    
                    dataEntries.append(dataEntry)
                case 4:
                    
                    var y = 0.1
                    
                    if thursdayCount != 0 {
                        y = (Double)(thursdayOverall) / (Double)(thursdayCount)
                        y.round()
                    }
                    
                    let dataEntry = BarChartDataEntry(x: Double(index),
                                                      y: y)
                    
                    dataEntries.append(dataEntry)
                case 5:
                    
                    var y = 0.1
                    
                    if fridayCount != 0 {
                        y = (Double)(fridayOverall) / (Double)(fridayCount)
                        y.round()
                    }
                    
                    let dataEntry = BarChartDataEntry(x: Double(index),
                                                      y: y)
                    
                    dataEntries.append(dataEntry)
                case 6:
                    
                    var y = 0.1
                    
                    if saturdayCount != 0 {
                        y = (Double)(saturdayOverall) / (Double)(saturdayCount)
                        y.round()
                    }
                    
                    let dataEntry = BarChartDataEntry(x: Double(index),
                                                      y: y)
                    
                    dataEntries.append(dataEntry)
                default:
                    break
                }
            }
            
            let chartDataSet = BarChartDataSet(values: dataEntries,
                                                label: "Reaction Time")
            
            chartDataSet.drawValuesEnabled = false
            
            chartDataSet.setColor(FlatSkyBlue())
            
            let dataSets = [chartDataSet]
            
            let data = BarChartData.init(dataSets: dataSets)
            
            barChartView.data = data
            
            //addLimitLine(with: overallTime, and: results.count)
            
            barChartView.animate(yAxisDuration: 2, easingOption: .easeOutBounce)
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










