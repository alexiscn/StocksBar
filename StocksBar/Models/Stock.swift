//
//  Stock.swift
//  StocksBar
//
//  Created by xu.shuifeng on 2019/4/26.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation
import Cocoa

class Stock: NSObject, Codable {
    
    var code: String
    
    /// 股票简称
    var symbol: String = "永辉超市"
    
    /// 今日开盘价
    var openPrice: Float = 0.0
    
    /// 昨日收盘价
    var lastClosedPrice: Float = 0.0
    
    /// 最近成交价格
    var current: Float = 10.24
    
    /// 最高成交价
    var high: Float = 0.0
    
    /// 最低成交价
    var low: Float = 0.0
    
    /// 最后更新日期
    var lastUpdatedDate: String = ""
    
    /// 最后更新时间
    var lastUpdatedTime: String = ""
    
    var reminder = Reminder()
    
    var isFavorited = false
    
    init(code: String) {
        self.code = code
    }
    
    func update(with newStock: Stock) {
        self.symbol = newStock.symbol
        self.openPrice = newStock.openPrice
        self.lastClosedPrice = newStock.lastClosedPrice
        if newStock.current == 0 {
            self.current = newStock.lastClosedPrice
        } else {
            self.current = newStock.current
        }
        self.high = newStock.high
        self.low = newStock.low
        self.lastUpdatedDate = newStock.lastUpdatedDate
        self.lastUpdatedTime = newStock.lastUpdatedTime
    }
}

extension Stock {
    
    var percent: Float {
        if lastClosedPrice == 0.0 || current == 0.0 {
            return 0.0
        }
        return (current - lastClosedPrice)/lastClosedPrice
    }
    
    var displayPercent: String {
        let p = percent
        if p > 0 {
            return String(format: "+%.2f%%", p * 100.0)
        } else if p < 0 {
            return String(format: "%.2f%%", p * 100.0)
        } else {
            return "0.0%"
        }
    }
    
    var displayColor: NSColor {
        if percent > 0 {
            return Colors.red
        } else if percent < 0 {
            return Colors.green
        } else {
            return Colors.gray
        }
    }
}
