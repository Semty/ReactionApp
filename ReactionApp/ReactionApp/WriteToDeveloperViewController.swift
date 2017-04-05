//
//  WriteToDeveloperViewController.swift
//  ReactionApp
//
//  Created by Ruslan Timchenko on 03.04.17.
//  Copyright © 2017 Ruslan Timchenko. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class WriteToDeveloperViewController:   UIViewController,
                                        MFMailComposeViewControllerDelegate {
    
    deinit {
        print("WriteToDeveloperViewController DEINIT")
    }
    
    func sendEmailButtonTapped(sender: AnyObject, and message: String) -> Bool {
        let mailComposeViewController = configuredMailComposeViewController(with: message)
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
            return true
        } else {
            self.dismiss(animated: true, completion: nil)
            return false
        }
    }
    
    func configuredMailComposeViewController(with message: String) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["TupAndUpOfficial@inbox.ru"])
        mailComposerVC.setSubject("Tap and Up Feedback")
        mailComposerVC.setMessageBody(message, isHTML: false)
        
        return mailComposerVC
    }
    /*
    func showSendMailErrorAlert() {
        
        let sendMailErrorAlertView =
        UIAlertController(title: "Could Not Send Email",
                          message: "Your device could not send e-mail.  Please check e-mail configuration and try again.",
                          preferredStyle: .alert)
        
        let cancelButton = UIAlertAction(title: "OK",
                                         style: .cancel,
                                         handler: nil)
        sendMailErrorAlertView.addAction(cancelButton)
        
        self.present(sendMailErrorAlertView, animated: true, completion: nil)
    }*/
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
}
