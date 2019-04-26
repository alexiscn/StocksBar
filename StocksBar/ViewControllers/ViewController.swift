//
//  ViewController.swift
//  StocksBar
//
//  Created by xu.shuifeng on 2019/4/24.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let s = Stock.parseSinaCode("永辉超市,9.160,9.000,9.270,9.530,9.160,9.270,9.280,97071150,910640035.000,26748,9.270,416700,9.260,186800,9.250,23900,9.240,25500,9.230,53900,9.280,330300,9.290,200600,9.300,88905,9.310,43800,9.320,2019-04-26,15:00:00,00") {
            print(s.percent)
        }
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

