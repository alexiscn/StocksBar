//
//  Reminder.swift
//  StocksBar
//
//  Created by xushuifeng on 2019/5/5.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Cocoa

class Reminder: Codable {
    
    enum CodingKeys: String, CodingKey {
        case up, down, percent
    }
    
    var up: Float = 0.0
    
    var down: Float = 0.0
    
    var percent: Float = 0.07
    
    var toasted: Bool = false
    
    init() {}
    
    func shouldToast(percent: Float, price: Float) -> Bool {
        if toasted {
            return false
        }
        if up != 0.0 && price >= up {
            return true
        }
        if down != 0.0 && price <= down {
            return true
        }
        if percent > self.percent || percent <= self.percent {
            return true
        }
        return false
    }
}
