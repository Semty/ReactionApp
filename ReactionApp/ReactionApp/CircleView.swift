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
            circleLayer.lineWidth = 2.5
            circleLayer.fillColor = Circle.sharedCircle.currentColor.cgColor
            circleLayer.strokeColor = FlatBlackDark().cgColor
            
            self.layer.addSublayer(circleLayer)
        } else {
            
            self.circleLayer.path = CGPath(ellipseIn: rect, transform: nil)
            if Circle.sharedCircle.state == .action {
                CATransaction.setDisableActions(true)
                circleLayer.fillColor = Circle.sharedCircle.currentColor.cgColor
                CATransaction.commit()
            } else {
                circleLayer.fillColor = Circle.sharedCircle.currentColor.cgColor
            }
        }
 
    }
    /*
    func runAnimation() {
        
        if circleLayer.superlayer == nil {
            circleLayer.path = getCirclePath()
            circleLayer.lineWidth = 3.0
            circleLayer.strokeColor = FlatBlackDark().cgColor
            circleLayer.fillColor   = Circle.sharedCircle.currentColor.cgColor
            
            let fadeAnimation = CABasicAnimation(keyPath: "strokeEnd")
            fadeAnimation.fromValue = 0
            fadeAnimation.toValue = 1.0
            fadeAnimation.duration = 2.0
            
            self.layer.addSublayer(circleLayer)
            circleLayer.add(fadeAnimation, forKey: "myCustomLoad")
        }
    }
    
    func getCirclePath() -> CGPath {
        let path = CGPath(ellipseIn: self.bounds, transform: nil)
        return path
    }
     */
}













