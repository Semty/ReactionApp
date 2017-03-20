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
    
// MARK: - Localizable Strings
    
    let circleStateNoneLString =
        NSLocalizedString("circleStateNoneLString", tableName: "Training",
                          bundle: Bundle.main,
                          value: "Tap and Hold Circle to Start!",
                          comment: "circleStateNoneLString")
    
    let circleStatePreparationLString =
        NSLocalizedString("circleStatePreparationLString", tableName: "Training",
                          bundle: Bundle.main,
                          value: "Wait Green Color",
                          comment: "circleStatePreparationLString")
    
    let circleStateActionLString =
        NSLocalizedString("circleStateActionLString", tableName: "Training",
                          bundle: Bundle.main,
                          value: "Throw the Circle!",
                          comment: "circleStateActionLString")
    
    let greetingLString =
        NSLocalizedString("greetingLString", tableName: "Training",
                          bundle: Bundle.main,
                          value: "Nice to see you again :)",
                          comment: "Greeting")
    
    let shortNoteIfLess150LString =
        NSLocalizedString("shortNoteIfLess150LString", tableName: "Training",
                          bundle: Bundle.main,
                          value: "What? It is incredible!",
                          comment: "Short Note if Result less than 150 ms")
    
    let shortNoteIfBetween150And200LString =
        NSLocalizedString("shortNoteIfBetween150And200LString", tableName: "Training",
                          bundle: Bundle.main,
                          value: "That's time better than 90% people have!",
                          comment: "Short Note if Result Between 150 ms and 200 ms")
    
    let shortNoteIfBetween200And230LString =
        NSLocalizedString("shortNoteIfBetween200And230LString", tableName: "Training",
                          bundle: Bundle.main,
                          value: "Nice job! It's cool time",
                          comment: "Short Note if Result Between 200 ms and 230 ms")
    
    let shortNoteIfBetween230And260LString =
        NSLocalizedString("shortNoteIfBetween230And260LString", tableName: "Training",
                          bundle: Bundle.main,
                          value: "Normal time",
                          comment: "Short Note if Result Between 230 ms and 260 ms")
    
    let shortNoteIfBetween260And300LString =
        NSLocalizedString("shortNoteIfBetween260And300LString", tableName: "Training",
                          bundle: Bundle.main,
                          value: "A few slowly",
                          comment: "Short Note if Result Between 260 ms and 300 ms")
    
    let shortNoteIfGreater300LString =
        NSLocalizedString("shortNoteIfGreater300LString", tableName: "Training",
                          bundle: Bundle.main,
                          value: "It is slowly, try again!",
                          comment: "Short Note if Result Greater than 300 ms")
    
// MARK: - shortInstructionLabel
    
    let realm = try! Realm()

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    public func setShortInstruction(duringCircleState circleState: CircleState) {
        
        if UserDefaultManager.shared.loadValue(forKey: .kFirstStartApp) as? Bool ?? true {
            
            switch circleState {
            case .none:
                self.text = circleStateNoneLString
            case .preparation:
                self.text = circleStatePreparationLString
            case .action:
                self.text = circleStateActionLString
            }
            
        } else {
            
            if UserDefaultManager.shared.loadValue(forKey: .kSimpleStartApp) as? Bool ?? true {
                
                UserDefaultManager.shared.save(value: false, forKey: .kSimpleStartApp)
                
                if self.text == "" {
                    self.text = greetingLString
                    
                } else {
                    self.text = nil
                }
                
            } else if self.text != "" && self.text != nil {
                self.text = nil
            }
        }
    }
    
    public func setShortNotes(withResultTime resultTime: Int) {
        
        switch resultTime {
        case Int.min..<150:
            self.text = shortNoteIfLess150LString
        case 150..<200:
            self.text = shortNoteIfBetween150And200LString
        case 200..<230:
            self.text = shortNoteIfBetween200And230LString
        case 230..<260:
            self.text = shortNoteIfBetween230And260LString
        case 260..<300:
            self.text = shortNoteIfBetween260And300LString
        case 300..<Int.max:
            self.text = shortNoteIfGreater300LString
        default:
            break
        }
        
    }

}







