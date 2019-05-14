//
//  AppPreferences.swift
//  StocksBar
//
//  Created by xu.shuifeng on 2019/5/5.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation

enum PercentViewStyle: Int {
    case rich = 0
    case plain
}

class AppPreferences {
    
    private struct Keys {
        static let PercentViewStyle = "PercentViewStyle"
        static let LoopDisplayStocks = "LoopDisplayStocks"
        static let RefreshInterval = "RefreshInterval"
    }
    
    static let shared = AppPreferences()
    
    var percentViewStyle: PercentViewStyle = .rich {
        didSet {
            UserDefaults.standard.set(percentViewStyle.rawValue, forKey: Keys.PercentViewStyle)
        }
    }
    
    var loopDisplayStocks: Bool = false {
        didSet {
            UserDefaults.standard.set(loopDisplayStocks, forKey: Keys.LoopDisplayStocks)
        }
    }
    
    var refreshInterval: Int = 1 {
        didSet {
            UserDefaults.standard.set(refreshInterval, forKey: Keys.RefreshInterval)
        }
    }
    
    private init() {
        percentViewStyle = PercentViewStyle(rawValue: UserDefaults.standard.integer(forKey: Keys.PercentViewStyle)) ?? .rich
        loopDisplayStocks = UserDefaults.standard.bool(forKey: Keys.LoopDisplayStocks)
        let interval = UserDefaults.standard.integer(forKey: Keys.RefreshInterval)
        refreshInterval = interval == 0 ? 1: interval
    }
}
