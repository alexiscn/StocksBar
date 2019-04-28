//
//  StockTableCellView.swift
//  StocksBar
//
//  Created by xu.shuifeng on 2019/4/28.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Cocoa

class StockTableCellView: NSTableCellView {

    @IBOutlet weak var symbolLabel: NSTextField!

    @IBOutlet weak var priceLabel: NSTextField!
    
    @IBOutlet weak var percentView: NSView!
    
    @IBOutlet weak var percentLabel: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    func update(_ stock: Stock) {
        symbolLabel.stringValue = stock.symbol
        priceLabel.stringValue = String(stock.current)
        
        percentView.wantsLayer = true
        percentView.layer?.cornerRadius = 4
        
        let color: NSColor
        let percent: String
        if stock.percent > 0 {
            color = Colors.red
            percent = String(format: "+%.2f%%", stock.percent * 100.0)
        } else if stock.percent < 0 {
            color = Colors.green
            percent = String(format: "%.2f%%", stock.percent * 100.0)
        } else {
            color = Colors.gray
            percent = "-"
        }
        percentLabel.stringValue = percent
        percentView.layer?.backgroundColor = color.cgColor
    }
    
}
