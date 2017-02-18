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
    
// MARK: - Helpful Functions
    
    public func setupBarLineChartView(chartView: BarLineChartViewBase) {
        
        chartView.chartDescription?.enabled = false
        
        chartView.drawGridBackgroundEnabled = false
        
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = false
        
        let xAxis = chartView.xAxis;
        xAxis.labelPosition = .bottom
        
        chartView.rightAxis.enabled = false
        
        let percentFormatter = NumberFormatter()
        percentFormatter.positiveSuffix = " ms"
        percentFormatter.negativeSuffix = " ms"
        
        let leftAxis = chartView.leftAxis
        leftAxis.labelFont = UIFont.init(name: "HelveticaNeue-Light", size: 8)!
        leftAxis.labelTextColor = FlatBlueDark()
        leftAxis.valueFormatter = DefaultAxisValueFormatter.init(formatter: percentFormatter)
    }
    
    public func styleData(data: ChartData) {
        
        let percentFormatter = NumberFormatter()
        percentFormatter.positiveSuffix = " ms"
        percentFormatter.negativeSuffix = " ms"
        
        data.setValueFont(UIFont.init(name: "HelveticaNeue-Light", size: 8))
        data.setValueTextColor(FlatBlack())
        
        data.setValueFormatter(DefaultValueFormatter.init(formatter: percentFormatter))
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}











