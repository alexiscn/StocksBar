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
        self.stock = stock
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
        guard let stock = stock else { return }
        
        let up = highPriceTextField.floatValue
        if up > 0 && up > stock.current {
            stock.reminder.up = up
        } else {
            stock.reminder.up = 0.0
        }
        
        let down = lowPriceTextField.floatValue
        if down > 0 && down < stock.current {
            stock.reminder.down = down
        } else {
            stock.reminder.down = 0.0
        }
        var percent = percentTextField.floatValue
        if percent > 0 {
            percent = min(percent, 100)
            stock.reminder.percent = percent / 100.0
        } else {
            stock.reminder.percent = 0.07
        }
        
        StockDataSource.shared.updateReminderOfStock(stock)
        closeCommand?()
    }
    
    @IBAction func tapCancelButton(_ sender: Any) {
        closeCommand?()
    }
    
}
