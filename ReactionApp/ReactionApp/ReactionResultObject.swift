//
//  ReactionResultObject.swift
//  ReactionApp
//
//  Created by Руслан on 18.02.17.
//  Copyright © 2017 Ruslan Timchenko. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class ReactionResultObject: RLMObject {
    
    dynamic var reactionTime = 0
    dynamic var reactionDateSince1970 = TimeInterval()
    
    dynamic var reactionDateDayHour = Double()
}
