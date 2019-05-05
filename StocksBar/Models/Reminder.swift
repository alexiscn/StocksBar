//
//  Reminder.swift
//  StocksBar
//
//  Created by xushuifeng on 2019/5/5.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Cocoa

class Reminder: Codable {
    
    var up: Float = 0.0
    
    var down: Float = 0.0
    
    var percent: Float = 0.07
    
    var toasted: Bool = false
    
    init() {}
}
