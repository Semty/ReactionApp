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

class RealmLineChartViewController: RealmDemoBaseViewController, ChartViewDelegate {

    @IBOutlet weak var chartView: LineChartView!
    
    var isPresented = false
    
    let realm = RLMRealm.default()
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.allButUpsideDown]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chartView.delegate = self
        
        self.setupBarLineChartView(chartView: chartView)
        
        // enable description text
        chartView.chartDescription?.enabled = false
        
        chartView.leftAxis.axisMaximum = 1000
        chartView.leftAxis.axisMinimum = 0
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        
        let marker = BalloonMarker.init(color: FlatGray(),
                                        font: UIFont.systemFont(ofSize: 12),
                                        textColor: FlatWhite(),
                                        insets: UIEdgeInsetsMake(8, 8, 20, 8))
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        chartView.marker = marker
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.isPresented = true
        
        self.setData()
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
    
    func maxAxisFrom(results: RLMResults<RLMObject>) -> Double {
        
        var baseAxis = Int.min
        
        for index in 0..<results.count {
            
            let reaction = results.object(at: index) as! ReactionResultObject
            
            if reaction.reactionTime > baseAxis {
                baseAxis = reaction.reactionTime
            }
        }
        
        return Double(baseAxis)
    }
    
    func minAxisFrom(results: RLMResults<RLMObject>) -> Double {
        
        var baseAxis = Int.max
        
        for index in 0..<results.count {
            
            let reaction = results.object(at: index) as! ReactionResultObject
            
            if reaction.reactionTime < baseAxis {
                baseAxis = reaction.reactionTime
            }
        }
        
        return Double(baseAxis)
    }
    
    func setData() {
        
        let results = realm.allObjects("ReactionResultObject")
        
        if results.count > 0 {
            
            chartView.leftAxis.axisMaximum = maxAxisFrom(results: results) + 50.0
            chartView.leftAxis.axisMinimum = minAxisFrom(results: results) - 50.0
            
            let set = RealmLineDataSet.init(results: results,
                                            xValueField: nil,
                                            yValueField: "reactionTime",
                                            label: "Reaction Time")
            set.drawCirclesEnabled = true
            
            set.mode = .cubicBezier
            set.drawValuesEnabled = false
            
            set.setColor(FlatBlue())
            set.setCircleColor(FlatBlue())
            
            set.lineWidth = 2.5
            set.circleRadius = 3
            
            let dataSets = [set]
            
            let data = LineChartData.init(dataSets: dataSets)
            self.styleData(data: data)
            
            chartView.zoom(scaleX: 1, scaleY: 1, x: 0, y: 0)
            chartView.data = data
            
            chartView.animate(xAxisDuration: 1.4, easingOption: .linear)
            chartView.animate(yAxisDuration: 1.4, easingOption: .easeOutCubic)
        }
    }
    
}
