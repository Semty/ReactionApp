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
    
    public var colorNone                        = FlatSkyBlueDark()  // default
    public var colorPreparation                 = FlatRed()      // default
    public var colorAction                      = FlatGreen()    // default
    
    public var animationDuration: TimeInterval  = 0.15           // default
    
    public var preparationTimeFrom              = UserDefaultManager.shared.loadValue(forKey: .kMinPreparationTime) as? Double ?? 2.0
    public var preparationTimeUntil             = UserDefaultManager.shared.loadValue(forKey: .kMaxPreparationTime) as? Double ?? 8.0
    
    public var maxSavingTime                    = UserDefaultManager.shared.loadValue(forKey: .kMaxSavingTime) as? Int ?? 1000
    
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






