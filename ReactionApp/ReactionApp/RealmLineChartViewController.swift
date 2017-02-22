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
            
            if (Int)(value) < (currentDayResults?.count)! {
                
                let date = currentDayResults?[(Int)(value)].reactionDate
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                return dateFormatter.string(from: date!)
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

// MARK: - RealmLineChartViewController

class RealmLineChartViewController: RealmDemoBaseViewController, ChartViewDelegate {

    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var barChartView: BarChartView!
    
    
    @IBOutlet weak var dateStatsSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var currentDateLabel: UILabel!
    
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    var isPresented = false
    
    var currentDayResults: Results<ReactionResultObject>?
    
    var currentDate = Date()
    
    var dayToday    = 0
    var weekDay     = 0
    var weekOfYear  = 0
    var monthToday  = 0
    
// MARK: - Private Variables
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.allButUpsideDown]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        axisFormatDelegate = self
        
        chartView.delegate = self
        barChartView.delegate = self
        
        self.setupBarLineChartView(chartView: chartView)
        self.setupBarLineChartView(chartView: barChartView)
        
        // enable description text
        chartView.chartDescription?.enabled = false
        
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.valueFormatter = axisFormatDelegate
        chartView.leftAxis.axisMinimum = 0
        //chartView.xAxis.granularity = 1
        //chartView.xAxis.granularityEnabled = true
        
        barChartView.leftAxis.axisMinimum = 0
        barChartView.xAxis.valueFormatter = axisFormatDelegate
        //barChartView.fitBars = true
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawGridLinesEnabled = false
        
        addMarker(forChartView: chartView)
        addMarker(forChartView: barChartView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.isPresented = true
        
        let date = Date(timeIntervalSinceNow: 0)
        currentDate = date
        
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
    
    func ignoreInteractions(withTime time: TimeInterval) {
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        DispatchQueue.main.asyncAfter(deadline: .now() + time,
                                      execute: {
                                        UIApplication.shared.endIgnoringInteractionEvents()
        })
    }
    
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
        
        do {
            let realm = try Realm()
            
            let results = realm.objects(ReactionResultObject.self).filter("reactionDate >= %@ && reactionDate <= %@",
                                                                     currentDate.startOfDay(), currentDate.endOfDay()).sorted(byProperty: "reactionDate", ascending: false)
            
            //var overallTime = 0
            let animationDuration: TimeInterval = 1.2
            
            if results.count > 0 {
                
                print("setDayData, OBJECTS = \(results.count)")
                
                self.currentDayResults = results
                
                var dataEntries: [ChartDataEntry] = []
                
                for (index, result) in results.enumerated() {
                    
                    let dataEntry = ChartDataEntry(x: Double(index), y: Double(result.reactionTime))
                    //overallTime += result.reactionTime
                    
                    dataEntries.append(dataEntry)
                }
                
                let chartDataSet = LineChartDataSet(values: dataEntries,
                                                    label: "Reaction Time Per Day")
                chartDataSet.drawCirclesEnabled = true
                chartDataSet.circleRadius = 4
                chartDataSet.setCircleColor(FlatSkyBlue())
                
                let resultsMultiplier = (CGFloat)(Double(results.count) / 20.0)
                let zoomMultiplier = resultsMultiplier > 1.0 ? resultsMultiplier : 1.0
                
                if chartView.scaleX != zoomMultiplier {
                    chartView.setScaleMinima(zoomMultiplier, scaleY: 1)  
                }
                
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
                
                self.chartView.animate(yAxisDuration: animationDuration, easingOption: .easeOutExpo)
                
                //self.ignoreInteractions(withTime: animationDuration)
            }
            
            chartView.isHidden = false
            barChartView.isHidden = true
            
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
    func setWeekData() {
        
        self.setDateInLabel(forPeriod: .week)
        
        do {
            let realm = try Realm()
            
            let results = realm.objects(ReactionResultObject.self).filter("reactionDate >= %@ && reactionDate <= %@",
                                                                     currentDate.startOfWeek(), currentDate.endOfWeek())
            
            let animationDuration: TimeInterval = 1.2
            
            if results.count > 0 {
                
                print("setWeekData, OBJECTS = \(results.count)")
                
                var dataEntries: [BarChartDataEntry] = []
                
                for index in 1...7 {
                    
                    let avgValue: Int = results.filter("reactionWeekday == %@", index).average(ofProperty: "reactionTime") ?? 0
                    
                    let dataEntry = BarChartDataEntry(x: Double(index - 1), y: Double(avgValue))
                    dataEntries.append(dataEntry)
                }
                
                let chartDataSet = BarChartDataSet(values: dataEntries,
                                                   label: "Average Reaction Time Per Weekday")
                
                chartDataSet.drawValuesEnabled = false
                
                chartDataSet.colors = [FlatSkyBlue()]
                
                let dataSets = [chartDataSet]
                
                let data = BarChartData.init(dataSets: dataSets)
                
                barChartView.data = data
                
                //addLimitLine(with: overallTime, and: results.count)
                
                self.barChartView.animate(yAxisDuration: animationDuration, easingOption: .easeOutBounce)
                
                //self.ignoreInteractions(withTime: animationDuration)
            }
            
            chartView.isHidden = true
            barChartView.isHidden = false
            
        } catch let error as NSError {
            fatalError(error.localizedDescription)
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










