//
//  PopoverAction.swift
//  StocksBar
//
//  Created by xu.shuifeng on 2019/4/26.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Cocoa

class PopoverAction {
    
    fileprivate class var appDelegate: AppDelegate {
        return NSApplication.shared.delegate as! AppDelegate
    }
    
    class func toggle() {
        if appDelegate.popover.isShown {
            close()
        } else {
            show()
        }
    }
    
    class func close() {
        guard appDelegate.popover.isShown else {
            return
        }
        appDelegate.popover.close()
    }
    
    class func show() {
        NSRunningApplication.current.activate(options: .activateIgnoringOtherApps)
        guard let button = appDelegate.statusItem.button else {
            return
        }
        appDelegate.popover.show(relativeTo: button.frame, of: button, preferredEdge: .minY)
    }
}
