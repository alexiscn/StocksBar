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
        if stock.percent > 0 {
            color = Colors.red
        } else if stock.percent < 0 {
            color = Colors.green
        } else {
            color = Colors.gray
        }
        percentView.layer?.backgroundColor = color.cgColor
    }
    
}
