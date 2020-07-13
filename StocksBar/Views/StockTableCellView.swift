//
//  StockTableCellView.swift
//  StocksBar
//
//  Created by xu.shuifeng on 2019/4/28.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Cocoa

class StockTableCellView: NSTableCellView {

    var deleteCommand: RelayCommand?
    
    @IBOutlet weak var deleteButton: NSButton!
    
    @IBOutlet weak var symbolLabel: NSTextField!

    @IBOutlet weak var priceLabel: NSTextField!
    
    @IBOutlet weak var percentView: NSView!
    
    @IBOutlet weak var percentLabel: NSTextField!
    
    @IBOutlet weak var dragButton: NSButton!
    
    @IBOutlet weak var deleteButtonLeadingConstraint: NSLayoutConstraint!

    @IBOutlet weak var contentViewLeadingConstaint: NSLayoutConstraint!
    
    @IBOutlet weak var contentViewTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var dragButtonTraillingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        wantsLayer = true
        layer?.backgroundColor = NSColor(white: 1.0, alpha: 0.6).cgColor
        percentView.wantsLayer = true
        percentView.layer?.cornerRadius = 4
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    func update(_ stock: Stock) {
        symbolLabel.stringValue = stock.symbol
        priceLabel.stringValue = String(format: "%.3f", stock.current)
        percentLabel.stringValue = stock.displayPercent
        
        switch AppPreferences.shared.percentViewStyle {
        case .rich:
            percentLabel.textColor = NSColor.white
            percentLabel.font = NSFont.systemFont(ofSize: NSFont.smallSystemFontSize)
            percentView.layer?.backgroundColor = stock.displayColor.cgColor
        case .plain:
            percentLabel.textColor = stock.displayColor
            percentLabel.font = NSFont.systemFont(ofSize: NSFont.systemFontSize)
            percentView.layer?.backgroundColor = NSColor.clear.cgColor
        }
    }
    
    func beginEditing() {
        deleteButtonLeadingConstraint.constant = 10
        contentViewLeadingConstaint.constant = 24
        contentViewTrailingConstraint.constant = 24
        dragButtonTraillingConstraint.constant = 10
        
        NSAnimationContext.runAnimationGroup { context in
            context.allowsImplicitAnimation = true
            context.duration = 0.2
            self.deleteButton.alphaValue = 1.0
            self.layoutSubtreeIfNeeded()
        }
    }
    
    func endEditing() {
        deleteButtonLeadingConstraint.constant = -24
        contentViewLeadingConstaint.constant = 0
        contentViewTrailingConstraint.constant = 0
        dragButtonTraillingConstraint.constant = -24
        
        NSAnimationContext.runAnimationGroup { context in
            context.allowsImplicitAnimation = true
            context.duration = 0.2
            self.deleteButton.alphaValue = 0.0
            self.layoutSubtreeIfNeeded()
        }
    }
    
    @IBAction func tapDeleteButton(_ sender: Any) {
        deleteCommand?()
    }
}
