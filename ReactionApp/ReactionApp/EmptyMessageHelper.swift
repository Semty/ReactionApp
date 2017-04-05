//
//  EmptyMessageHelper.swift
//  ReactionApp
//
//  Created by Ruslan Timchenko on 05.04.17.
//  Copyright © 2017 Ruslan Timchenko. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Localizable Strings

let emptyMessageTitle =
    NSLocalizedString("emptyMessageTitle",
                      tableName: "Settings", bundle: Bundle.main,
                      value: "Empty Message",
                      comment: "Empty Message Title")
let okButtonTitle =
    NSLocalizedString("okButtonTitle",
                      tableName: "Settings", bundle: Bundle.main,
                      value: "OK",
                      comment: "Ok Button Title")

class EmptyMessageHelper {
    
    let alertController = UIAlertController(title: emptyMessageTitle,
                                            message: nil,
                                            preferredStyle: .alert)
    
    let okButton = UIAlertAction(title: okButtonTitle,
                                 style: .default,
                                 handler: nil)
    
    init() {
        alertController.addAction(okButton)
    }
    
    deinit {
        print("EmptyMessageHelper DEINIT")
    }
}
