//
//  StockSearchCellView.swift
//  StocksBar
//
//  Created by xu.shuifeng on 2019/4/30.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Cocoa

class StockSearchCellView: NSTableCellView {

    @IBOutlet weak var symbolLabel: NSTextField!
    
    @IBOutlet weak var codeLabel: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    func update(_ stock: Stock) {
        symbolLabel.stringValue = stock.symbol
        codeLabel.stringValue = stock.code
    }
    
}
