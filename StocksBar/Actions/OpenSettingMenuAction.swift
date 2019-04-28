//
//  OpenSettingMenuAction.swift
//  StocksBar
//
//  Created by xu.shuifeng on 2019/4/28.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Cocoa

class OpenSettingMenuAction {
    
    class func perform(_ sender: NSView) {
        
        let delegate = NSApplication.shared.delegate as! AppDelegate
        
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(delegate.quit), keyEquivalent: "Q"))
        
        NSMenu.popUpContextMenu(menu, with: NSApp.currentEvent!, for: sender)
    }
    
}
