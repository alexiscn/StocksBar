//
//  OpenAboutWindowAction.swift
//  StocksBar
//
//  Created by xu.shuifeng on 2019/5/16.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Cocoa

class OpenAboutWindowAction {
    class func perform() {
        AboutWindowController.default.window?.orderFront(nil)
    }
}
