//
//  ReactionViewController.swift
//  ReactionApp
//
//  Created by Руслан on 15.02.17.
//  Copyright © 2017 Ruslan Timchenko. All rights reserved.
//

import UIKit
import RandomKit

class ReactionViewController: UIViewController {
    
// MARK: - Properties
    
    @IBOutlet weak var circleView: CircleView!
    
    @IBOutlet weak var reactionResultLabel: UILabel!
    @IBOutlet weak var shortInstructionLabel: UILabel!
    
// MARK: - Private Properties
    
    private var startTime:  CFTimeInterval?
    private var endTime:    CFTimeInterval?
    
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
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// MARK: - Helpful Functions
    
    func circleTouchStarted() {
        
        if self.reactionResultLabel.text != nil {
            self.reactionResultLabel.text = nil
        }
        
        if self.shortInstructionLabel.text != nil {
            self.shortInstructionLabel.text = "Wait Green Color.."
        }
        
        Circle.sharedCircle.state = .preparation
        self.circleView.setNeedsDisplay()
        
        self.timer = Timer.scheduledTimer(withTimeInterval: Double.random(within: Circle.sharedCircle.currentPreparationTime),
                                         repeats: false) { (_) in
                                            
                                            if Circle.sharedCircle.state == .preparation {
                                                
                                                Circle.sharedCircle.state = .action
                                                self.circleView.setNeedsDisplay()
                                                
                                                self.startTime = CACurrentMediaTime()
                                                
                                                if self.shortInstructionLabel.text != nil {
                                                    self.shortInstructionLabel.text = "Throw the Circle!"
                                                }
                                            }
        }
        
        RunLoop.current.add(self.timer, forMode: .commonModes)
        
        UIView.animate(withDuration: Circle.sharedCircle.animationDuration) { 
            
            self.circleView.transform  = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
        }
    }
    
    func circleTouchEnded() {
        
        Circle.sharedCircle.state = .none
        
        UIView.animate(withDuration: Circle.sharedCircle.animationDuration) {
            
            self.circleView.transform  = CGAffineTransform.identity
            self.circleView.setNeedsDisplay()
        }
    }
    
    func touchEndedForCircle(with touch: UITouch, and event: UIEvent?) {
        
        if Circle.sharedCircle.state == .preparation {
            
            self.circleTouchEnded()
            
            self.startTime = nil
            
            self.reactionResultLabel.text = "Too Early!"
            
            self.timer.invalidate()
            
        } else if Circle.sharedCircle.state == .action {
            
            if self.shortInstructionLabel.text != nil {
                self.shortInstructionLabel.text = nil
            }
            
            self.endTime = CACurrentMediaTime()
            
            circleTouchEnded()
            
            if let reactionResult = self.reactionTime {
                
                self.reactionResultLabel.text = "\(reactionResult) ms"
                
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










