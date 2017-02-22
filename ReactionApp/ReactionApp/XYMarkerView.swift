//
//  XYMarkerView.swift
//  ReactionApp
//
//  Created by Руслан on 22.02.17.
//  Copyright © 2017 Ruslan Timchenko. All rights reserved.
//

import Foundation
import Charts

class XYMarkerView: BalloonMarker {
    
    open var xAxisValueFormatter: IAxisValueFormatter?
    fileprivate var yFormatter = NumberFormatter()
    
    public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets,
                xAxisValueFormatter: IAxisValueFormatter)
    {
        super.init(color: color, font: font, textColor: textColor, insets: insets)
        self.xAxisValueFormatter = xAxisValueFormatter
        yFormatter.minimumFractionDigits = 1
        yFormatter.maximumFractionDigits = 1
    }
    
    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight)
    {
        setLabel("\(yFormatter.string(from: NSNumber(floatLiteral: entry.y))!)\n\(xAxisValueFormatter!.stringForValue(entry.x, axis: nil))")
    }
    
}

// y = yFormatter.string(from: NSNumber(floatLiteral: entry.y))!
// x = xAxisValueFormatter!.stringForValue(entry.x, axis: nil)
