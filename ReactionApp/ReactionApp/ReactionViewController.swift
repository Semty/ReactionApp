//
//  ReactionViewController.swift
//  ReactionApp
//
//  Created by Руслан on 15.02.17.
//  Copyright © 2017 Ruslan Timchenko. All rights reserved.
//

import UIKit
import RandomKit
import ChameleonFramework
import Charts

class ReactionViewController: UIViewController {
    
// MARK: - Properties
    
    @IBOutlet weak var circleImageView: UIImageView!
    
// MARK: - Class Properties
    
    static let circleAnimationDuration: TimeInterval = 0.2
    
// MARK: - Private Properties
    
    private let circleRedImage      = UIImage.init(named: "circleRed")
    private let circleGreenImage    = UIImage.init(named: "circleGreen")
    private let circleBlueImage     = UIImage.init(named: "circleBlue")
    private let circleVioletImage   = UIImage.init(named: "circleViolet")
    
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
    
    //private var isHoldingCircle     = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.circleImageView.alpha = 0.75
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// MARK: - Helpful Functions
    
    func circleTouchStarted() {
        
        self.circleImageView.image = self.circleRedImage
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(within: 2...8), execute: {
            
            if self.circleImageView.image == self.circleRedImage {
                
                self.startTime = CACurrentMediaTime()
                
                self.circleImageView.image = self.circleGreenImage
            }
        })
        
        UIView.animate(withDuration: ReactionViewController.circleAnimationDuration) { 
            
            self.circleImageView.transform  = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
        }
    }
    
    func circleTouchEnded() {
        
        UIView.animate(withDuration: ReactionViewController.circleAnimationDuration) { 
            
            self.circleImageView.transform  = CGAffineTransform.identity
            
            self.circleImageView.image = self.circleBlueImage
        }
    }
    
    func touchEndedForCircle(with touch: UITouch, and event: UIEvent?) {
        
        if self.circleImageView.image == self.circleRedImage {
            
            self.circleTouchEnded()
            
            self.startTime = nil
            
            print("\n\nToo Early!\n")
            
        } else if self.circleImageView.image == self.circleGreenImage {
            
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
        
        if hitView == self.circleImageView {
        
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










