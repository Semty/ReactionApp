//
//  CircleView.swift
//  ReactionApp
//
//  Created by Руслан on 16.02.17.
//  Copyright © 2017 Ruslan Timchenko. All rights reserved.
//

import UIKit
import ChameleonFramework

class CircleView: UIView {
    
    let strokeWidth: CGFloat = 3.0
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(Circle.sharedCircle.currentColor.cgColor)
        
        context?.setStrokeColor(FlatBlack().cgColor)
        context?.setLineWidth(2)
        
        let newRect = CGRect.init(x: rect.origin.x + strokeWidth / 2,
                                  y: rect.origin.y + strokeWidth / 2,
                                  width: rect.width - strokeWidth,
                                  height: rect.width - strokeWidth)
        
        context?.fillEllipse(in: rect)
        context?.strokeEllipse(in: newRect)
        
        context?.fillPath()
    }

}
