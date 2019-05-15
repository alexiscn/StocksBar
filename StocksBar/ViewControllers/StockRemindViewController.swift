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
    
    var closeCommand: RelayCommand?
    
    @IBOutlet weak var symbolLabel: NSTextField!
    
    @IBOutlet weak var codeLabel: NSTextField!
    
    @IBOutlet weak var priceLabel: NSTextField!
    
    @IBOutlet weak var percentLabel: NSTextField!
    
    @IBOutlet weak var highPriceTextField: NSTextField!
    
    @IBOutlet weak var lowPriceTextField: NSTextField!
    
    @IBOutlet weak var percentTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func update(stock: Stock) {
        symbolLabel.stringValue = stock.symbol
        codeLabel.stringValue = stock.code
        priceLabel.stringValue = String(format: "%.2f", stock.current)
        percentLabel.stringValue = stock.displayPercent
        percentLabel.textColor = stock.displayColor
        
        let remind = stock.reminder
        if remind.up > 0 {
            highPriceTextField.stringValue = String(format: "%.2f", remind.up)
        }
        if remind.down > 0 {
            lowPriceTextField.stringValue = String(format: "%.2f", remind.down)
        }
        percentTextField.stringValue =  String(stock.reminder.percent * 100)
    }
    
    @IBAction func tapSaveButton(_ sender: Any) {
        closeCommand?()
    }
    
    @IBAction func tapCancelButton(_ sender: Any) {
        closeCommand?()
    }
    
}
