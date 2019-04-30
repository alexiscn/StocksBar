//
//  AppDelegate.swift
//  StocksBar
//
//  Created by xu.shuifeng on 2019/4/24.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Cocoa
import SnapKit

typealias RelayCommand = () -> Void

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    let api = StocksAPI()
    
    let popover = NSPopover()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        if let button = statusItem.button {
            button.title = "StocksBar"
            button.action = #selector(toggle)
        }
        
        let controller = MainViewController()
        controller.view.frame = NSRect(x: 0, y: 0, width: 300, height: 450)
        
        popover.backgroundColor = NSColor(white: 247.0/255, alpha: 1.0)
        popover.contentViewController = controller
        popover.contentSize = NSSize(width: 300, height: 450)
        popover.appearance = NSAppearance(named: .aqua)
        popover.animates = false
        popover.behavior = .transient
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}

extension AppDelegate {
    
    @objc func quit() {
        StockDataSource.shared.save()
        NSApplication.shared.terminate(self)
    }

    @objc func toggle() {
        PopoverAction.toggle()
    }
    
    func update(stock: Stock?) {
        guard let stock = stock else {
            return
        }
        let title = String(format: "%@ %.2f %@", stock.symbol, stock.current, stock.percentString)
        statusItem.title = title
    }
    
    @objc func changeRefreshInterval(_ sender: NSMenuItem) {
        
    }
}
