//
//  AboutViewController.swift
//  StocksBar
//
//  Created by xushuifeng on 2019/5/14.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Cocoa

class AboutViewController: NSViewController {
    
    @IBOutlet weak var versionLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            versionLabel.stringValue = version
        }
    }
    
}
