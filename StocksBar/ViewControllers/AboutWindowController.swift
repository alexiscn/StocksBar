//
//  AboutWindowController.swift
//  StocksBar
//
//  Created by xushuifeng on 2019/5/14.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Cocoa

class AboutWindowController: NSWindowController {

    static let `default`: AboutWindowController = {
        //let storyboard = NSStoryboard(name: "")
        let storyboard = NSStoryboard(name: "AboutWindow", bundle: nil)
        let controller = storyboard.instantiateInitialController() as! AboutWindowController
        return controller
    }()
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }

}
