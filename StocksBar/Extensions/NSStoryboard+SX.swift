//
//  NSStoryboard+SX.swift
//  StocksBar
//
//  Created by xushuifeng on 2019/5/6.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Cocoa

extension NSStoryboard {
    
    static var main: NSStoryboard {
        return NSStoryboard(name: "Main", bundle: nil)
    }
    
    func instantiateViewController<T>(ofType type: T.Type) -> T {
        return instantiateController(withIdentifier: String(describing: type)) as! T
    }
}
