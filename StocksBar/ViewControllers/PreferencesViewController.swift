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
    @IBOutlet weak var loopDisplayStockButton: NSButton!
    @IBOutlet weak var tabView: NSTabView!
    @IBOutlet weak var plainStyleButton: NSButton!
    @IBOutlet weak var richStyleButton: NSButton!
    @IBOutlet weak var percentView: NSView!
    @IBOutlet weak var intervalComboBox: NSComboBox!
    
    private let intervals: [Int] = [1, 2, 3, 5, 10]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        percentView.wantsLayer = true
        percentView.layer?.cornerRadius = 4
        percentView.layer?.backgroundColor = Colors.red.cgColor
        
        launchOnSystemStartButton.state = LaunchAtLogin.isEnabled ? .on : .off
        loopDisplayStockButton.state = AppPreferences.shared.loopDisplayStocks ? .on : .off
        let isRich = AppPreferences.shared.percentViewStyle == .rich
        plainStyleButton.state = isRich ? .off : .on
        richStyleButton.state = isRich ? .on : .off
        
        intervalComboBox.removeAllItems()
        intervalComboBox.addItems(withObjectValues: intervals)
        if let index = intervals.firstIndex(where: { $0 == AppPreferences.shared.refreshInterval }) {
            intervalComboBox.selectItem(at: index)
        } else {
            intervalComboBox.selectItem(at: 0)
        }
    }
    
    @IBAction func tapLaunchOnSystemStartButton(_ sender: Any) {
        LaunchAtLogin.isEnabled = !LaunchAtLogin.isEnabled
    }
    
    @IBAction func tapStyleRadioButton(_ sender: NSButton) {
        let buttons = [plainStyleButton, richStyleButton]
        buttons.forEach { $0?.state = $0 == sender ? .on: .off }
        if sender == plainStyleButton {
            AppPreferences.shared.percentViewStyle = .plain
        } else {
            AppPreferences.shared.percentViewStyle = .rich
        }
    }
    
    @IBAction func tapLoopDisplayStockButton(_ sender: Any) {
        AppPreferences.shared.loopDisplayStocks = !AppPreferences.shared.loopDisplayStocks
    }
    
    @IBAction func intervalComboBoxValueChanged(_ sender: Any) {
        let index = intervalComboBox.indexOfSelectedItem
        if let interval = intervalComboBox.itemObjectValue(at: index) as? Int {
            AppPreferences.shared.refreshInterval = interval
        }
    }
    
}
