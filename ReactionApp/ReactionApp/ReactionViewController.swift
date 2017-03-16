//
//  ReactionViewController.swift
//  ReactionApp
//
//  Created by Руслан on 15.02.17.
//  Copyright © 2017 Ruslan Timchenko. All rights reserved.
//

import UIKit
import LTMorphingLabel
import RandomKit
import RealmSwift
import Sparrow

class ReactionViewController: UIViewController, SPRequestPermissionEventsDelegate {
    
// MARK: - Localizable Strings
    
    let tooEarlyLString =
        NSLocalizedString("tooEarlyLString", tableName: "Training",
                          bundle: Bundle.main, value: "Too Early!",
                          comment: "tooEarlyLString")
    
    let instructionForTimeLString =
        NSLocalizedString("instructionForTimeLString", tableName: "Training",
                          bundle: Bundle.main, value: "Here will be your time :)",
                          comment: "instructionForTimeLString")
    
    let instructionForNoteLString =
        NSLocalizedString("instructionForNoteLString", tableName: "Training",
                          bundle: Bundle.main, value: "That's all, Let's go!",
                          comment: "instructionForNoteLString")
    
    let msLString = NSLocalizedString("ms", tableName: "Training",
                                      bundle: Bundle.main,
                                      value: "ms", comment: "ms")
    
    let errorLString = NSLocalizedString("error", tableName: "Training",
                                      bundle: Bundle.main,
                                      value: "Error", comment: "error")
    
// MARK: - IBOutlet Properties
    
    @IBOutlet weak var circleView: CircleView!
    
    @IBOutlet weak var reactionResultLabel: ShrinkingLTMortphingLabel!
    @IBOutlet weak var shortInstructionLabel: ShortInstructionLabel!
    
// MARK: - Private Properties
    
    private var startTime:  CFTimeInterval?
    private var endTime:    CFTimeInterval?
    
    private var timer = Timer()
    
    private var backgroundQueue = DispatchQueue(label: "com.rstimchenko.backgroundQueue", qos: .background,
                                                attributes: DispatchQueue.Attributes.concurrent,
                                                autoreleaseFrequency: .inherit,
                                                target: nil)
    
// MARK: - Public Properties
    
    public var reactionTime: Int? {
        
        if self.startTime != nil && self.endTime != nil {
            
            let resultTime = (self.endTime! - self.startTime!) * 1000
            
            return Int(resultTime)
            
        } else {
            return nil
        }
    }
    
    public var permissionAssistant = SPRequestPermissionAssistant.modules.dialog.interactive.create(with: [.Notification])

    override func viewDidLoad() {
        super.viewDidLoad()
        
        permissionAssistant.eventsDelegate = self
        
        if UserDefaultManager.shared.loadValue(forKey: .kShowPermissions) == nil {
            permissionAssistant.present(on: self.tabBarController!)
            
            let defaultRingTime = NotificationManager.shared.currentDate(withHour: 20, andMinute: 00)
            NotificationManager.shared.setUpLocalNotification(date: defaultRingTime)
            UserDefaultManager.shared.save(value: defaultRingTime, forKey: .kRingTime)
        }
        
        self.shortInstructionLabel.morphingEffect   = .evaporate
        self.reactionResultLabel.morphingEffect     = .evaporate
        
        self.shortInstructionLabel.morphingDuration = 0.2
        self.reactionResultLabel.morphingDuration = 0.2
        
        //self.circleView.transform  = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
        self.circleView.alpha = 0.0
        
        UserDefaultManager.shared.save(value: true, forKey: .kSimpleStartApp)
        
        // *** REMOVE ALL REACTIONS FOR DEBUG ***
        /*
        backgroundQueue.async {
            
            let realm = self.getRealmInBack()
                
            do {
                try realm.write {
                    realm.deleteAll()
                }
            } catch let deleteError as NSError {
                fatalError(deleteError.localizedDescription)
            }
         
            
            // *** ADDING RANDOM REACTIONS FOR DEBUG ***
            
            for _ in 0..<1500 {
                
                let testReaction = ReactionResultObject()
                testReaction.save()
            }
 
        }
        */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        UIView.animate(withDuration: 0.25) {
            
            //self.circleView.transform  = CGAffineTransform.identity
            self.circleView.alpha = 1.0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.shortInstructionLabel.setShortInstruction(duringCircleState: .none)
        
        self.reactionResultLabel.adjustFontSizeToFitText(newText: self.reactionResultLabel.text!)
        //self.shortInstructionLabel.adjustFontSizeToFitText(newText: self.shortInstructionLabel.text!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        //self.circleView.transform  = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
        self.circleView.alpha = 0.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// MARK: - Helpful Functions
    
    func saveResult(withTime time: Int) {
        backgroundQueue.async {
            let reactionObject = ReactionResultObject()
            
            reactionObject.reactionTime = time
            
            reactionObject.save()
        }
    }
    
    func circleTouchStarted() {
            
        UIView.animate(withDuration: Circle.sharedCircle.animationDuration) {
                
            self.circleView.transform  = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
        }
            
        self.shortInstructionLabel.setShortInstruction(duringCircleState: .preparation)
            
        if self.reactionResultLabel.text != nil {
            self.reactionResultLabel.text = nil
        }
            
        Circle.sharedCircle.state = .preparation
            
        self.circleView.setNeedsDisplay()
            
        self.timer = Timer.scheduledTimer(timeInterval: Double.random(within: Circle.sharedCircle.currentPreparationTime),
                                          target: self,
                                          selector: #selector(actionTimerHire),
                                          userInfo: nil,
                                          repeats: false)
            
        RunLoop.current.add(self.timer, forMode: .commonModes)
    }
    
    func circleTouchEnded() {
        
        Circle.sharedCircle.state = .none
        
        UIView.animate(withDuration: Circle.sharedCircle.animationDuration) {
            
            self.circleView.transform  = CGAffineTransform.identity
        }
        self.circleView.setNeedsDisplay()
    }
    
    func touchEndedForCircle(with touch: UITouch, and event: UIEvent?) {
        
        if Circle.sharedCircle.state == .preparation {
            
            self.circleTouchEnded()
            
            self.startTime = nil
            
            self.reactionResultLabel.text = tooEarlyLString
            
            self.timer.invalidate()
            
            self.shortInstructionLabel.setShortInstruction(duringCircleState: .none)
            
        } else if Circle.sharedCircle.state == .action {
            
            circleTouchEnded()
            
            self.endTime = CACurrentMediaTime()
            
            if let reactionResult = self.reactionTime {
                
                backgroundQueue.async {
                    
                    if UserDefaultManager.shared.loadValue(forKey: .kFirstStartApp) == nil {  // First Start Application
                        
                        UserDefaultManager.shared.save(value: false, forKey: .kFirstStartApp)
                        
                        DispatchQueue.main.async {
                            self.reactionResultLabel.text = self.instructionForTimeLString
                            self.shortInstructionLabel.text = self.instructionForNoteLString
                        }
                        
                    } else {                                                            // Default Situation
                        
                        DispatchQueue.main.async {
                            self.reactionResultLabel.numberOfLines = 1
                            
                            self.reactionResultLabel.text = "\(reactionResult) \(self.msLString)"
                            
                            self.shortInstructionLabel.setShortNotes(withResultTime: reactionResult)
                        }
                        
                        if reactionResult <= Circle.sharedCircle.maxSavingTime {
                            self.saveResult(withTime: reactionResult)
                        }
                    }
                }
            } else {
                self.reactionResultLabel.text = errorLString
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            
            self.circleView.setNeedsDisplay()
            
            self.reactionResultLabel.adjustFontSizeToFitText(newText: self.reactionResultLabel.text!)
            self.shortInstructionLabel.adjustFontSizeToFitText(newText: self.shortInstructionLabel.text!)
            
        }, completion: nil)
    }
 
// MARK: - Realm
    
    func getRealmInBack() -> Realm {
        do {
            let realm = try Realm()
            return realm
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
// MARK: - Timer Selector
    
    func actionTimerHire() {
        if Circle.sharedCircle.state == .preparation {
            
            Circle.sharedCircle.state = .action
            self.circleView.setNeedsDisplay()
            
            self.startTime = CACurrentMediaTime()
            
            self.shortInstructionLabel.setShortInstruction(duringCircleState: .action)
        }
    }
    
// MARK: - SPRequestPermissionEventsDelegate
    
    func didHide() {
        
    }
    
    func didAllowPermission(permission: SPRequestPermissionType) {
        UserDefaultManager.shared.save(value: true, forKey: .kShowPermissions)
    }
    
    func didDeniedPermission(permission: SPRequestPermissionType) {
        UserDefaultManager.shared.save(value: false, forKey: .kShowPermissions)
    }
    
    func didSelectedPermission(permission: SPRequestPermissionType) {
        
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
