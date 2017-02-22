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
    
    let circleLayer = CAShapeLayer()
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        if circleLayer.superlayer == nil {
            
            self.circleLayer.path = CGPath(ellipseIn: rect, transform: nil)
            circleLayer.lineWidth = 3.0
            circleLayer.fillColor = Circle.sharedCircle.currentColor.cgColor
            circleLayer.strokeColor = FlatBlackDark().cgColor
            
            self.layer.addSublayer(circleLayer)
        } else {
            
            if Circle.sharedCircle.state == .action {
                CATransaction.setDisableActions(true)
                circleLayer.fillColor = Circle.sharedCircle.currentColor.cgColor
                CATransaction.commit()
            } else {
                circleLayer.fillColor = Circle.sharedCircle.currentColor.cgColor
            }
        }
    }
}
