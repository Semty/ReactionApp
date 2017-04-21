//
//  VideoAdManager.swift
//  ReactionApp
//
//  Created by Ruslan Timchenko on 20.04.17.
//  Copyright © 2017 Ruslan Timchenko. All rights reserved.
//

import Foundation
import UIKit
import Eureka
import GoogleMobileAds

class VideoAdManager: NSObject, GADRewardBasedVideoAdDelegate {
    
    let videoAdID = "ca-app-pub-8402016319891167/9560430533"
    
    weak var settingsVC: SettingsViewController?
    
    init(withSettingsVC settingsVC: SettingsViewController?) {
        self.settingsVC = settingsVC
        super.init()
        
        GADRewardBasedVideoAd.sharedInstance().delegate = self
        self.loadAd()
    }
    
// MARK: - Helpful Functions
    
    func watchAd() {
        if GADRewardBasedVideoAd.sharedInstance().isReady {
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: settingsVC!)
        }
    }
    
    func loadAd() {
        if !GADRewardBasedVideoAd.sharedInstance().isReady {
            let request = GADRequest()
            GADRewardBasedVideoAd.sharedInstance().load(request,
                                                        withAdUnitID: videoAdID)
        }
    }
    
// MARK: - GADRewardBasedVideoAdDelegate
    
    /// Tells the delegate that the reward based video ad has rewarded the user.
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
    }
    
    
    /// Tells the delegate that the reward based video ad failed to load.
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didFailToLoadWithError error: Error) {
        loadAd()
    }
    
    
    /// Tells the delegate that a reward based video ad was received.
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {

    }
    
    
    /// Tells the delegate that the reward based video ad opened.
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        
    }
    
    
    /// Tells the delegate that the reward based video ad started playing.
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        
    }
    
    
    /// Tells the delegate that the reward based video ad closed.
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        loadAd()
    }
    
    
    /// Tells the delegate that the reward based video ad will leave the application.
    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        
    }
}
