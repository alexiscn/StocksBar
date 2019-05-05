//
//  PreferencesViewController.swift
//  StocksBar
//
//  Created by xu.shuifeng on 2019/5/5.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Cocoa
import LaunchAtLogin

class PreferencesViewController: NSViewController {
    
    @IBOutlet weak var launchOnSystemStartButton: NSButton!
    
    @IBOutlet weak var tabView: NSTabView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        launchOnSystemStartButton.state = LaunchAtLogin.isEnabled ? .on: .off
    }
    
    @IBAction func tapLaunchOnSystemStartButton(_ sender: Any) {
        if launchOnSystemStartButton.state == .on {
            launchOnSystemStartButton.state = .off
            LaunchAtLogin.isEnabled = false
        } else {
            launchOnSystemStartButton.state = .on
            LaunchAtLogin.isEnabled = true
        }
    }
    
}
