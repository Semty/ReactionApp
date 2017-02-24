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
        chartView.noDataTextColor = FlatBlue()
        chartView.noDataText = "We cannot find reaction stats for this period :("
        
        chartView.chartDescription?.enabled = false
        
        chartView.drawGridBackgroundEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.setScaleEnabled(false)
        
        chartView.dragEnabled = true
        chartView.leftAxis.drawLimitLinesBehindDataEnabled = true
        chartView.pinchZoomEnabled = true
        chartView.scaleXEnabled = true
        chartView.clipValuesToContentEnabled = true
        
        let fontSize = fontSizeForCurrentUIDevice()
        
        let xAxis = chartView.xAxis;
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont.init(name: "HelveticaNeue-CondensedBold", size: fontSize)!
        xAxis.labelTextColor = FlatBlue()
        //xAxis.avoidFirstLastClippingEnabled = true
        //xAxis.labelCount = 7
        //xAxis.granularity = 1
        
        chartView.rightAxis.enabled = false
        
        let msFormatter = NumberFormatter()
        msFormatter.positiveSuffix = " ms"
        msFormatter.negativeSuffix = " ms"
        
        let leftAxis = chartView.leftAxis
        leftAxis.labelFont = UIFont.init(name: "HelveticaNeue-CondensedBold", size: fontSize)!
        leftAxis.labelTextColor = FlatBlue()
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
                                  textColor: FlatWhite(),
                                  insets: UIEdgeInsetsMake(8, 8, 20, 8),
                                  xAxisValueFormatter: xAxisValueFormatter)
        
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        chartView.marker = marker
    }
    
    func addBalloonMarker(forChartView chartView: BarLineChartViewBase) {
        
        let marker = BalloonMarker(color: FlatGray(),
                                  font: UIFont.systemFont(ofSize: 12),
                                  textColor: FlatWhite(),
                                  insets: UIEdgeInsetsMake(8, 8, 20, 8))
        
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        chartView.marker = marker
    }
    
    func addLimitLine(with overallTime: Int, count: Int, andChartView chartView: BarLineChartViewBase) {
        
        chartView.leftAxis.removeAllLimitLines()
        
        let limitTime = (Double)(overallTime) / (Double)(count)
        let limitLine = ChartLimitLine(limit: limitTime, label: String.init(format: "%1.1f ms", limitTime))
        limitLine.lineColor = FlatSkyBlue().withAlphaComponent(0.3)
        limitLine.valueFont = .boldSystemFont(ofSize: 8.0)
        
        limitLine.lineDashLengths = [8.0]
        
        chartView.leftAxis.addLimitLine(limitLine)
    }
    
    func createReactionDayChartData(withDataEntries dataEntries: [ChartDataEntry], chartView: BarLineChartViewBase,
                             andrResultsCount resultsCount: Int) -> LineChartData {
        
        let chartDataSet = LineChartDataSet(values: dataEntries,
                                            label: "Reaction Time Per Day")
        
        chartDataSet.circleRadius = 4
        chartDataSet.setCircleColor(FlatSkyBlue())
        
        chartDataSet.mode = .horizontalBezier
        chartDataSet.drawValuesEnabled = false
        
        chartDataSet.setColor(FlatSkyBlue())
        chartDataSet.drawFilledEnabled = true
        chartDataSet.fillAlpha = 0.2
        chartDataSet.fillColor = FlatSkyBlue()
        chartDataSet.setDrawHighlightIndicators(true)
        
        chartDataSet.lineWidth = 2
        
        if resultsCount > 2 {
            chartView.autoScaleMinMaxEnabled = true
        }
        
        let dataSets = [chartDataSet]
        
        let data = LineChartData.init(dataSets: dataSets)
        
        return data
    }
    
    func createReactionWeekChartData(withDataEntries dataEntries: [BarChartDataEntry], chartView: BarLineChartViewBase) -> BarChartData {
        
        chartView.xAxis.granularity = 1.0
        
        let chartDataSet = BarChartDataSet(values: dataEntries,
                                            label: "Average Reaction Time Per Last 7 Days")
        
        chartDataSet.colors = ChartColorTemplates.material()
        
        let dataSets = [chartDataSet]
        
        let data = BarChartData.init(dataSets: dataSets)
        
        return data
    }
    
    func createReactionAllTimeChartData(withDataEntries dataEntries: [BarChartDataEntry], chartView: BarLineChartViewBase) -> BarChartData {
        
        chartView.xAxis.granularity = 1.0
        
        let chartDataSet = BarChartDataSet(values: dataEntries,
                                           label: "Average Reaction per all Time")
        
        chartDataSet.colors = ChartColorTemplates.colorful()
        
        let dataSets = [chartDataSet]
        
        let data = BarChartData.init(dataSets: dataSets)
        
        return data
    }
    
    /*
    func xAxisValueForWeekdayStats(withDayNumber number: Double) -> String {
        
        switch number {
        case 0:
            return "Sun"
        case 1:
            return "Mon"
        case 2:
            return "Tues"
        case 3:
            return "Wed"
        case 4:
            return "Thurs"
        case 5:
            return "Fri"
        case 6:
            return "Sat"
        default:
            return ""
        }
    }
    */
    func getCurrentDateInfo(unit: Calendar.Component, from date: Date) -> Int {
        return Calendar.current.component(unit, from: date)
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
