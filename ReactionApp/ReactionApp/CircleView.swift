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
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.addEllipse(in: rect)
        
        context?.setFillColor(Circle.sharedCircle.currentColor.cgColor)
        
        context?.fillPath()  
    }

}
