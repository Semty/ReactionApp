//
//  Circle.swift
//  ReactionApp
//
//  Created by Руслан on 16.02.17.
//  Copyright © 2017 Ruslan Timchenko. All rights reserved.
//

import UIKit
import ChameleonFramework

enum CircleState {
    
    case none
    case preparation
    case action
    
}

class Circle: NSObject {
    
    static let sharedCircle                     = Circle()    // singleton
    
    public var state: CircleState               = .none
    
    public var colorNone                        = FlatBlue()  // default
    public var colorPreparation                 = FlatRed()   // default
    public var colorAction                      = FlatGreen() // default
    
    public var animationDuration: TimeInterval  = 0.15        // default
    
    public var preparationTimeFrom              = 2.0         // default
    public var preparationTimeUntil             = 8.0         // default
    
    public var maxSavingTime                    = 1000        // default
    
    public var currentColor: UIColor {
        
        let circle = Circle.sharedCircle
        
        switch circle.state {
        case .none:
            return circle.colorNone
        case .preparation:
            return circle.colorPreparation
        case .action:
            return circle.colorAction
        }
    }
    
    public var currentPreparationTime: ClosedRange<Double> {
        
        return Circle.sharedCircle.preparationTimeFrom...Circle.sharedCircle.preparationTimeUntil
    }
    
}






