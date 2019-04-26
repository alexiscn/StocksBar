//
//  Stock.swift
//  StocksBar
//
//  Created by xu.shuifeng on 2019/4/26.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation

class Stock {
    
    var code: String
    
    /// 股票简称
    var symbol: String = ""
    
    /// 今日开盘价
    var openPrice: Float = 0.0
    
    /// 昨日收盘价
    var lastClosedPrice: Float = 0.0
    
    /// 最近成交价格
    var current: Float = 0.0
    
    /// 最高成交价
    var high: Float = 0.0
    
    /// 最低成交价
    var low: Float = 0.0
    
    init(code: String) {
        self.code = code
    }
    
    var percent: Float {
        if lastClosedPrice == 0.0 {
            return 0.0
        }
        return (current - lastClosedPrice)/lastClosedPrice
    }
    
    class func parseSinaCode(_ code: String, value: String) -> Stock? {
        let components = value.split(separator: ",").map { return String($0) }
        let stock = Stock(code: code)
        stock.symbol = components[0]
        stock.openPrice = Float(components[1]) ?? 0.0
        stock.lastClosedPrice = Float(components[2]) ?? 0.0
        stock.current = Float(components[3]) ?? 0.0
        
        return stock
    }
}
