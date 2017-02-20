//
//  ReactionViewController.swift
//  ReactionApp
//
//  Created by Руслан on 15.02.17.
//  Copyright © 2017 Ruslan Timchenko. All rights reserved.
//

import UIKit
import RandomKit
import Realm
import RealmSwift

class ReactionViewController: UIViewController {
    
// MARK: - Properties
    
    @IBOutlet weak var circleView: CircleView!
    
    @IBOutlet weak var reactionResultLabel: UILabel!
    @IBOutlet weak var shortInstructionLabel: shortInstructionLabel!
    
// MARK: - Private Properties
    
    private var startTime:  CFTimeInterval?
    private var endTime:    CFTimeInterval?
    
    private let realm = try! Realm()
    
    private var timer = Timer()
    
// MARK: - Public Properties
    
    public var reactionTime: Int? {
        
        if self.startTime != nil && self.endTime != nil {
            
            let resultTime = (self.endTime! - self.startTime!) * 1000
            
            return Int(resultTime)
            
        } else {
            return nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let objects = realm.objects(ReactionResultObject.self)
        
        print("WE HAVE \(objects.count) REACTION OBJECTS!!!")
        
        self.shortInstructionLabel.setShortInstruction(duringCircleState: .none)
        
        if self.shortInstructionLabel.text == nil {
            self.shortInstructionLabel.text = "Nice to see you again!"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// MARK: - Helpful Functions
    
    func saveResult(withTime time: Int) {
        
        let reactionObject = ReactionResultObject()
        
        let dateNow = Date.init(timeIntervalSinceNow: 0)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH.mm"
        
        reactionObject.reactionTime = time
        reactionObject.reactionDateSince1970 = dateNow.timeIntervalSince1970
        
        reactionObject.save()
    }
    
    func saveFirstStartAppState(state: Bool) {
        
        let firstStartApp = FirstStartApp()
        firstStartApp.isFirstStart = state
        
        firstStartApp.save()
    }
    
    func circleTouchStarted() {
        
        UIView.animate(withDuration: Circle.sharedCircle.animationDuration) {
            
            self.circleView.transform  = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
        }
        
        if self.reactionResultLabel.text != nil {
            self.reactionResultLabel.text = nil
        }
        
        self.shortInstructionLabel.setShortInstruction(duringCircleState: .preparation)
        
        Circle.sharedCircle.state = .preparation
        self.circleView.setNeedsDisplay()
        
        self.timer = Timer.scheduledTimer(withTimeInterval: Double.random(within: Circle.sharedCircle.currentPreparationTime),
                                         repeats: false) { (_) in
                                            
                                            if Circle.sharedCircle.state == .preparation {
                                                
                                                Circle.sharedCircle.state = .action
                                                self.circleView.setNeedsDisplay()
                                                
                                                self.startTime = CACurrentMediaTime()
                                                
                                                self.shortInstructionLabel.setShortInstruction(duringCircleState: .action)
                                            }
        }
        
        RunLoop.current.add(self.timer, forMode: .commonModes)
    }
    
    func circleTouchEnded() {
        
        Circle.sharedCircle.state = .none
    }
    
    func touchEndedForCircle(with touch: UITouch, and event: UIEvent?) {
        
        UIView.animate(withDuration: Circle.sharedCircle.animationDuration) {
            
            self.circleView.transform  = CGAffineTransform.identity
            self.circleView.setNeedsDisplay()
        }
        
        if Circle.sharedCircle.state == .preparation {
            
            self.circleTouchEnded()
            
            self.startTime = nil
            
            self.reactionResultLabel.text = "Too Early!"
            
            self.timer.invalidate()
            
            self.shortInstructionLabel.setShortInstruction(duringCircleState: .none)
            
        } else if Circle.sharedCircle.state == .action {
            
            circleTouchEnded()
            
            self.endTime = CACurrentMediaTime()
            
            if let reactionResult = self.reactionTime {                             // First Start Application
                
                if realm.objects(FirstStartApp.self).first?.isFirstStart ?? true {
                    
                    self.reactionResultLabel.numberOfLines = 2
                    self.reactionResultLabel.text = "Here will be\nyour time :)"
                    self.shortInstructionLabel.text = "That's all, Let's go!"
                    
                    saveFirstStartAppState(state: false)
                    
                } else {                                                            // Default Situation
                    
                    if reactionResult <= Circle.sharedCircle.maxSavingTime {
                        saveResult(withTime: reactionResult)
                    }
                    
                    self.reactionResultLabel.numberOfLines = 1
                    
                    self.reactionResultLabel.text = "\(reactionResult) ms"
                    
                    self.shortInstructionLabel.setShortNotes(withResultTime: reactionResult)
                }
                
            } else {
                self.reactionResultLabel.text = "Error"
            }
        }
    }
    
// MARK: - Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        
        let pointOnTheMainView = touch.location(in: self.view)
        
        let hitView = self.view.hitTest(pointOnTheMainView, with: event)
        
        if hitView == self.circleView {
        
            self.circleTouchStarted()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.touchEndedForCircle(with: touches.first!, and: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.touchEndedForCircle(with: touches.first!, and: event)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
