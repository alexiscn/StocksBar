//
//  Stock.swift
//  StocksBar
//
//  Created by xu.shuifeng on 2019/4/26.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation

class Stock: NSObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case code
        case symbol
        case openPrice
        case lastClosedPrice
        case current
        case high
        case low
        case lastUpdatedDate
        case lastUpdatedTime
    }
    
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
    
    var lastUpdatedDate: String = ""
    
    var lastUpdatedTime: String = ""
    
    var reminder = Reminder()
    
    init(code: String) {
        self.code = code
    }
    
    var isFavorited = false
    
    var percent: Float {
        if lastClosedPrice == 0.0 {
            return 0.0
        }
        return (current - lastClosedPrice)/lastClosedPrice
    }
    
    var percentString: String {
        let p = percent
        if p > 0 {
            return String(format: "+%.2f%%", p * 100.0)
        } else if p < 0 {
            return String(format: "%.2f%%", p * 100.0)
        } else {
            return "0.0%"
        }
    }
    
    var shouldToastNotification: Bool {
        if !reminder.toasted && percent != 0.0 && (percent >= reminder.up || percent <= reminder.down) {
            return true
        }
        return false
    }
    
    class func parseSinaCode(_ code: String, value: String) -> Stock? {
        let components = value.split(separator: ",").map { return String($0) }
        let stock = Stock(code: code)
        stock.symbol = components[0]
        stock.openPrice = Float(components[1]) ?? 0.0
        stock.lastClosedPrice = Float(components[2]) ?? 0.0
        stock.current = Float(components[3]) ?? 0.0
        
        if components.count >= 32 {
            stock.lastUpdatedDate = components[30]
            stock.lastUpdatedTime = components[31]
        }
        
        return stock
    }
    
    func update(with newStock: Stock) {
        self.symbol = newStock.symbol
        self.openPrice = newStock.openPrice
        self.lastClosedPrice = newStock.lastClosedPrice
        self.current = newStock.current
        self.high = newStock.high
        self.low = newStock.low
        self.lastUpdatedDate = newStock.lastUpdatedDate
        self.lastUpdatedTime = newStock.lastUpdatedTime
    }
}
