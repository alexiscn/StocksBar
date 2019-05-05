//
//  Preferences.swift
//  StocksBar
//
//  Created by xu.shuifeng on 2019/5/5.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation

class Preferences {
    
    private struct Keys {
        static let showBackgroundOfChangePercent = "showBackgroundOfChangePercent"
    }
    
    static let shared = Preferences()
    
    private init() {}
    
    var showBackgroundOfChangePercent: Bool {
        get { return (UserDefaults.standard.value(forKey: Keys.showBackgroundOfChangePercent) as? Bool) ?? true }
        set { UserDefaults.standard.set(newValue, forKey: Keys.showBackgroundOfChangePercent) }
    }
}
