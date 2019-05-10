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
        case up, down, percent, toastDate
    }
    
    var up: Float = 0.0
    
    var down: Float = 0.0
    
    var percent: Float = 0.07
    
    var toastDate: Date = Date.distantPast
    
    var toasted: Bool = false
    
    init() {}
    
    func checkRemind(percent: Float, price: Float) -> Bool {
        
        if toasted || NSCalendar.current.isDateInToday(toastDate) {
            return false
        }
        if up != 0.0 && price >= up {
            return true
        }
        if down != 0.0 && price <= down {
            return true
        }
        if percent > self.percent || percent <= -self.percent {
            return true
        }
        return false
    }
    
    func remindText(percent: Float, price: Float) -> String? {
        if up != 0.0 && price >= up {
            return "高于卖出目标价\(up)了"
        }
        if down != 0.0 && price <= down {
            return "低于买入目标价\(down)了"
        }
        if percent >= 0.07 {
            return String(format: "涨幅为%.2f%%，超过7%%了", percent * 100)
        }
        if percent <= -0.07 {
            return String(format: "跌幅为%.2f%%，超过7%%了", percent * 100)
        }
        return nil
    }
}
