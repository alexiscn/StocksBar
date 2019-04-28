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
        priceLabel.floatValue = stock.current
        
        percentView.wantsLayer = true
        percentView.layer?.cornerRadius = 6
        percentView.layer?.backgroundColor = Colors.red.cgColor
    }
    
}
