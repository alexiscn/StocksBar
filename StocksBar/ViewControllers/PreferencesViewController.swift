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
    @IBOutlet weak var plainStyleButton: NSButton!
    @IBOutlet weak var richStyleButton: NSButton!
    @IBOutlet weak var percentView: NSView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        percentView.wantsLayer = true
        percentView.layer?.cornerRadius = 4
        percentView.layer?.backgroundColor = Colors.red.cgColor
        
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
    
    @IBAction func tapStyleRadioButton(_ sender: NSButton) {
        let buttons = [plainStyleButton, richStyleButton]
        buttons.forEach { $0?.state = $0 == sender ? .on: .off }
    }
}
