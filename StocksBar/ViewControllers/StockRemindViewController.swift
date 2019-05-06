//
//  StockRemindViewController.swift
//  StocksBar
//
//  Created by xushuifeng on 2019/5/6.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Cocoa

class StockRemindViewController: NSViewController {

    var stock: Stock?
    
    @IBOutlet weak var symbolLabel: NSTextField!
    
    @IBOutlet weak var codeLabel: NSTextField!
    
    @IBOutlet weak var priceLabel: NSTextField!
    
    @IBOutlet weak var percentLabel: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func update(stock: Stock) {
        symbolLabel.stringValue = stock.symbol
        codeLabel.stringValue = stock.code
        priceLabel.stringValue = String(format: "%.2f", stock.current)
        percentLabel.stringValue = stock.percentString
    }
    
}
