//
//  PermissionsDataSource.swift
//  ReactionApp
//
//  Created by Руслан on 02.03.17.
//  Copyright © 2017 Ruslan Timchenko. All rights reserved.
//

import Foundation
import Sparrow

class PermissionsDataSource: SPRequestPermissionDialogInteractiveDataSource {
    
// MARK: - Localization Strings
    
    let titleForPermissionCameraLString =
        NSLocalizedString("titleForPermissionCameraLString", tableName: "Permission",
                          bundle: Bundle.main,
                          value: "Enable Camera",
                          comment: "Title for Camera Permission")
    
    let titleForPermissionPhotoLibraryLString =
        NSLocalizedString("titleForPermissionPhotoLibraryLString", tableName: "Permission",
                          bundle: Bundle.main,
                          value: "Enable Photo Library",
                          comment: "Title for Photo Library Permission")
    
    let titleForPermissionNotificationLString =
        NSLocalizedString("titleForPermissionNotificationLString", tableName: "Permission",
                          bundle: Bundle.main,
                          value: "Enable Notifications",
                          comment: "Title for Notifications Permission")
    
    let titleForPermissionMicrophoneLString =
        NSLocalizedString("titleForPermissionMicrophoneLString", tableName: "Permission",
                          bundle: Bundle.main,
                          value: "Enable Microphone",
                          comment: "Title for Microphone Permission")
    
    let titleForPermissionCalendarLString =
        NSLocalizedString("titleForPermissionCalendarLString", tableName: "Permission",
                          bundle: Bundle.main,
                          value: "Enable Calendar",
                          comment: "Title for Calendar Permission")
    
    let titleForPermissionLocationLString =
        NSLocalizedString("titleForPermissionLocationLString", tableName: "Permission",
                          bundle: Bundle.main,
                          value: "Enable Location",
                          comment: "Title for Location Permission")
    
    let headerTitleLString =
        NSLocalizedString("headerTitleLString", tableName: "Permission",
                          bundle: Bundle.main,
                          value: "Hello!",
                          comment: "Header Title")
    
    let headerSubtitleLString =
        NSLocalizedString("headerSubtitleLString", tableName: "Permission",
                          bundle: Bundle.main,
                          value: "Application Needs Permission",
                          comment: "Header Subtitle")
    
    let topAdviceTitleLString =
        NSLocalizedString("topAdviceTitleLString", tableName: "Permission",
                          bundle: Bundle.main,
                          value: "Allow Permission, Please. This Helps to use Application",
                          comment: "Top Advice Title")
    
    let bottomAdviceTitleLString =
        NSLocalizedString("bottomAdviceTitleLString", tableName: "Permission",
                          bundle: Bundle.main,
                          value: "You can Manage Permissions in Settings",
                          comment: "Bottom Advice Title")
    
    let underDialogAdviceTitleLString =
        NSLocalizedString("underDialogAdviceTitleLString", tableName: "Permission",
                          bundle: Bundle.main,
                          value: "Swipe to Hide",
                          comment: "Under Dialog Advice Title")
    
// MARK: - Functions
    
    override func titleForPermissionControl(_ permission: SPRequestPermissionType) -> String {
        var title = String()
        switch permission {
        case .Camera:
            title = titleForPermissionCameraLString
        case .PhotoLibrary:
            title = titleForPermissionPhotoLibraryLString
        case .Notification:
            title = titleForPermissionNotificationLString
        case .Microphone:
            title = titleForPermissionMicrophoneLString
        case .Calendar:
            title = titleForPermissionCalendarLString
        case .Location:
            title = titleForPermissionLocationLString
        }
        return title
    }
    
    override func headerTitle() -> String {
        return headerTitleLString
    }
    
    override func headerSubtitle() -> String {
        return headerSubtitleLString
    }
    
    override func topAdviceTitle() -> String {
        return topAdviceTitleLString
    }
    
    override func bottomAdviceTitle() -> String {
        return bottomAdviceTitleLString
    }
    
    override func underDialogAdviceTitle() -> String {
        return underDialogAdviceTitleLString
    }
}
