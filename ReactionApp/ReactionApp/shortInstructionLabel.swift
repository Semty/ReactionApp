//
//  shortInstructionLabel.swift
//  ReactionApp
//
//  Created by Руслан on 18.02.17.
//  Copyright © 2017 Ruslan Timchenko. All rights reserved.
//

import UIKit
import LTMorphingLabel
import RealmSwift

class ShortInstructionLabel: ShrinkingLTMortphingLabel {
    
    let realm = try! Realm()

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    public func setShortInstruction(duringCircleState circleState: CircleState) {
        
        if realm.objects(FirstStartApp.self).first?.isFirstStart ?? true {
            // DEBUG:
            print("\n\nFirstStartApp objects in Realm = ",
                  realm.objects(FirstStartApp.self).count,
                  "; (must be 1 or 0)\n")
            //
            
            switch circleState {
            case .none:
                self.text = "Tap and Hold Circle to Start!"
            case .preparation:
                self.text = "Wait Green Color"
            case .action:
                self.text = "Throw the Circle!"
            }
            
        } else {
            
            if realm.objects(SimpleStartApp.self).first?.isSimpleStart ?? true {
                // DEBUG:
                print("\n\nSimpleStartApp objects in Realm = ",
                      realm.objects(SimpleStartApp.self).count,
                      "; (must be 1 or 0)\n")
                //
                
                if self.text == "" {
                    self.text = "Nice to see you again!"
                    saveSimpleStartApp(to: false)
                    
                } else {
                    self.text = nil
                    saveSimpleStartApp(to: false)
                }
                
            } else if self.text != "" && self.text != nil {
                self.text = nil
            }
        }
    }
    
    private func saveSimpleStartApp(to state: Bool) {
        let simpleStartApp = SimpleStartApp()
        simpleStartApp.isSimpleStart = state
        simpleStartApp.save()
    }
    
    public func setShortNotes(withResultTime resultTime: Int) {
        
        switch resultTime {
        case Int.min..<150:
            self.text = "What? It is incredible!"
        case 150..<200:
            self.text = "That's time better than 90% people have!"
        case 200..<230:
            self.text = "Nice job! It's cool time"
        case 230..<260:
            self.text = "Normal time, it's ok"
        case 260..<300:
            self.text = "A few slowly, but it's ok"
        case 300..<Int.max:
            self.text = "It is slowly, try again!"
        default:
            break
        }
        
    }

}







