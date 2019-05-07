//
//  Preferences.swift
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

class Preferences {
    
    private struct Keys {
        static let PercentViewStyle = "PercentViewStyle"
    }
    
    static let shared = Preferences()
    
    var percentViewStyle: PercentViewStyle = .rich {
        didSet {
            UserDefaults.standard.set(percentViewStyle.rawValue, forKey: Keys.PercentViewStyle)
        }
    }
    
    private init() {
        percentViewStyle = PercentViewStyle(rawValue: UserDefaults.standard.integer(forKey: Keys.PercentViewStyle)) ?? .rich
    }
}
