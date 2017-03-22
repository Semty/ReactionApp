//
//  RealmBarChartViewController.swift
//  ReactionApp
//
//  Created by Руслан on 18.02.17.
//  Copyright © 2017 Ruslan Timchenko. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
import Charts

class RealmDemoBaseViewController: UIViewController {
    
// MARK: - Localizable Strings
    
    let msLString = NSLocalizedString("ms", tableName: "Stats",
                                      bundle: Bundle.main,
                                      value: " ms", comment: "ms")

    let noDataTextLString =
        NSLocalizedString("chartView.noDataText",
                          tableName: "Stats", bundle: Bundle.main,
                          value: "We cannot find reaction stats for this period :(",
                          comment: "No data text in chart")
    
    let dayStatsLString = NSLocalizedString("reactionTimePerDay", tableName: "Stats",
                                            bundle: Bundle.main,
                                            value: "Reaction Time Per Day",
                                            comment: "Reaction Time Per Day")
    
    let weekStatsLString = NSLocalizedString("reactionTimePerWeek", tableName: "Stats",
                                             bundle: Bundle.main,
                                             value: "Average Reaction Time Per Last 7 Days",
                                             comment: "Average Reaction Time Per Week")
    
    let allTimeStatsLString = NSLocalizedString("reactionTimePerAllTime",
                                                tableName: "Stats",
                                                bundle: Bundle.main,
                                                value: "Average Reaction per all Time",
                                                comment: "Average Reaction per all Time")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// MARK: - Main Function
    
    public func setupBarLineChartView(chartView: BarLineChartViewBase) {
        
        chartView.alpha = 0.0
        
        chartView.noDataFont = UIFont.init(name: "HelveticaNeue-CondensedBold", size: 12)!
        chartView.noDataTextColor = UIColor.white
        chartView.noDataText = noDataTextLString
        
        chartView.chartDescription?.enabled = false
        
        chartView.drawGridBackgroundEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.setScaleEnabled(false)
        
        chartView.dragEnabled = true
        //chartView.leftAxis.drawLimitLinesBehindDataEnabled = true
        chartView.pinchZoomEnabled = true
        chartView.scaleXEnabled = true
        chartView.clipValuesToContentEnabled = true
        
        let fontSize = fontSizeForCurrentUIDevice()
        
        let xAxis = chartView.xAxis;
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont.init(name: "HelveticaNeue-CondensedBold", size: fontSize)!
        xAxis.labelTextColor = UIColor.white
        //xAxis.avoidFirstLastClippingEnabled = true
        //xAxis.labelCount = 7
        //xAxis.granularity = 1
        
        chartView.rightAxis.enabled = false
        
        chartView.legend.textColor = UIColor.white
        
        let msFormatter = NumberFormatter()
        msFormatter.positiveSuffix = msLString
        msFormatter.negativeSuffix = msLString
        
        let leftAxis = chartView.leftAxis
        leftAxis.labelFont = UIFont.init(name: "HelveticaNeue-CondensedBold", size: fontSize)!
        leftAxis.labelTextColor = UIColor.white
        leftAxis.valueFormatter = DefaultAxisValueFormatter.init(formatter: msFormatter)
        
        if chartView is LineChartView {
            addBalloonMarker(forChartView: chartView)
            chartView.xAxis.avoidFirstLastClippingEnabled = true
        } else if chartView is BarChartView {
            addXYMarker(forChartView: chartView, withXAxisValueFormatter: chartView.xAxis.valueFormatter!)
        }
    }
    
// MARK: - Support Functions
    
    func addXYMarker(forChartView chartView: BarLineChartViewBase, withXAxisValueFormatter xAxisValueFormatter: IAxisValueFormatter) {
        
        let marker = XYMarkerView(color: FlatGray(),
                                  font: UIFont.systemFont(ofSize: 12),
                                  textColor: UIColor.white,
                                  insets: UIEdgeInsetsMake(8, 8, 20, 8),
                                  xAxisValueFormatter: xAxisValueFormatter)
        
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        chartView.marker = marker
    }
    
    func addBalloonMarker(forChartView chartView: BarLineChartViewBase) {
        
        let marker = BalloonMarker(color: FlatGray(),
                                  font: UIFont.systemFont(ofSize: 12),
                                  textColor: UIColor.white,
                                  insets: UIEdgeInsetsMake(8, 8, 20, 8))
        
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        chartView.marker = marker
    }
    
    func addLimitLine(with overallTime: Int, count: Int, andChartView chartView: BarLineChartViewBase) {
        
        chartView.leftAxis.removeAllLimitLines()
        
        let limitTime = (Double)(overallTime) / (Double)(count)
        let limitLine = ChartLimitLine(limit: limitTime, label: String.init(format: "%1.1f\(msLString)", limitTime))
        limitLine.lineColor = FlatSkyBlue().withAlphaComponent(0.3)
        limitLine.valueFont = .boldSystemFont(ofSize: 8.0)
        limitLine.valueTextColor = UIColor.white
        
        limitLine.lineDashLengths = [8.0]
        
        chartView.leftAxis.addLimitLine(limitLine)
    }
    
    func createReactionDayChartData(withDataEntries dataEntries: [ChartDataEntry], chartView: BarLineChartViewBase,
                             andrResultsCount resultsCount: Int) -> LineChartData {
        
        let chartDataSet = LineChartDataSet(values: dataEntries,
                                            label: dayStatsLString)
        
        chartDataSet.circleRadius = 4
        chartDataSet.setCircleColor(FlatSkyBlue())
        
        chartDataSet.mode = .horizontalBezier
        chartDataSet.drawValuesEnabled = false
        
        chartDataSet.setColor(FlatSkyBlue())
        chartDataSet.drawFilledEnabled = true
        chartDataSet.fillAlpha = 0.2
        chartDataSet.fillColor = FlatSkyBlue()
        chartDataSet.setDrawHighlightIndicators(false)
        
        chartDataSet.lineWidth = 2
        /*
        if resultsCount > 2 {
            chartView.autoScaleMinMaxEnabled = true
        }
        */
        let dataSets = [chartDataSet]
        
        let data = LineChartData.init(dataSets: dataSets)
        
        return data
    }
    
    func createReactionWeekChartData(withDataEntries dataEntries: [BarChartDataEntry], chartView: BarLineChartViewBase) -> BarChartData {
        
        chartView.xAxis.granularity = 1.0
        
        let chartDataSet = BarChartDataSet(values: dataEntries,
                                            label: weekStatsLString)
        
        chartDataSet.colors = ChartColorTemplates.material()
        chartDataSet.valueTextColor = UIColor.white
        
        let dataSets = [chartDataSet]
        
        let data = BarChartData.init(dataSets: dataSets)
        
        return data
    }
    
    func createReactionAllTimeChartData(withDataEntries dataEntries: [BarChartDataEntry], chartView: BarLineChartViewBase) -> BarChartData {
        
        chartView.xAxis.granularity = 1.0
        
        let chartDataSet = BarChartDataSet(values: dataEntries,
                                           label: allTimeStatsLString)
        
        chartDataSet.colors = ChartColorTemplates.colorful()
        chartDataSet.valueTextColor = UIColor.white
        
        let dataSets = [chartDataSet]
        
        let data = BarChartData.init(dataSets: dataSets)
        
        return data
    }

    func getCurrentDateInfo(unit: Calendar.Component, from date: Date) -> Int {
        return Calendar.sharedCurrent.component(unit, from: date)
    }
    
    func fontSizeForCurrentUIDevice() -> CGFloat {
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 960:
                return 8.0
            case 1136:
                return 9.0
            case 1334:
                return 10.0
            case 2208:
                return 11.0
            default:
                return 12.0
            }
        } else {
            return 12.0
        }
    }
    
    /*
    public func styleData(data: ChartData) {
     
        let msFormatter = NumberFormatter()
        msFormatter.positiveSuffix = " ms"
        msFormatter.negativeSuffix = " ms"
        
        data.setValueFont(UIFont.init(name: "HelveticaNeue-Light", size: 8))
        data.setValueTextColor(FlatBlack())
        
        data.setValueFormatter(DefaultValueFormatter.init(formatter: msFormatter))
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
