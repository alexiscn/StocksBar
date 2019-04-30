//
//  OpenSettingMenuAction.swift
//  StocksBar
//
//  Created by xu.shuifeng on 2019/4/28.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Cocoa

class OpenSettingMenuAction: NSObject {
    
    class func perform(_ sender: NSView) {
        
        let delegate = NSApplication.shared.delegate as! AppDelegate
        
        let menu = NSMenu()
        
        let timeIntervalMenu = NSMenu()
        timeIntervalMenu.addItem(withTitle: "1", action: #selector(delegate.changeRefreshInterval(_:)), keyEquivalent: "")
        timeIntervalMenu.addItem(withTitle: "2", action: #selector(delegate.changeRefreshInterval(_:)), keyEquivalent: "")
        timeIntervalMenu.addItem(withTitle: "3", action: #selector(delegate.changeRefreshInterval(_:)), keyEquivalent: "")
        timeIntervalMenu.addItem(withTitle: "5", action: #selector(delegate.changeRefreshInterval(_:)), keyEquivalent: "")
        
        let updateTimeItem = NSMenuItem(title: "Refresh Interval", action: nil, keyEquivalent: "")
        updateTimeItem.submenu = timeIntervalMenu
        
        menu.addItem(updateTimeItem)
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(delegate.quit), keyEquivalent: "Q"))
        
        NSMenu.popUpContextMenu(menu, with: NSApp.currentEvent!, for: sender)
    }
}
