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
    
// MARK: - Private Properties
    
    private var startTime:  CFTimeInterval?
    private var endTime:    CFTimeInterval?
    
// MARK: - Public Properties
    
    public var reactionTime: String? {
        
        if self.startTime != nil && self.endTime != nil {
            
            let resultTime = (self.endTime! - self.startTime!) * 1000
            
            return String.init(format: "%1.f", resultTime)
            
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
        
        Circle.sharedCircle.state = .preparation
        self.circleView.setNeedsDisplay()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(within: Circle.sharedCircle.currentPreparationTime),
                                      execute: {
            
            if Circle.sharedCircle.state == .preparation {
                
                Circle.sharedCircle.state = .action
                self.circleView.setNeedsDisplay()
                
                self.startTime = CACurrentMediaTime()
            }
        })
        
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
            
            print("\n\nToo Early!\n")
            
        } else if Circle.sharedCircle.state == .action {
            
            self.endTime = CACurrentMediaTime()
            
            circleTouchEnded()
            
            if let reactionResult = self.reactionTime {
                print("Congratulations! Your reaction time = \(reactionResult) ms")
            } else {
                print("We are Sorry, but Something Went Wrong")
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










