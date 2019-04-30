//
//  StockFooterView.swift
//  StocksBar
//
//  Created by xu.shuifeng on 2019/4/28.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Cocoa

class StockFooterView: NSView {

    private var iconView: NSImageView!
    
    private var lastUpdatedLabel: NSTextField!
    
    private var settingButton: NSButton!
    
    override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
        commonInit()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        commonInit()
    }
    
    private func commonInit() {
        
        iconView = NSImageView(image: NSImage(named: "icon_stock")!)
        addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
        }
        
        lastUpdatedLabel = NSTextField()
        lastUpdatedLabel.isBordered = false
        lastUpdatedLabel.backgroundColor = .clear
        lastUpdatedLabel.isEditable = false
        lastUpdatedLabel.alignment = .center
        lastUpdatedLabel.font = NSFont.systemFont(ofSize: NSFont.smallSystemFontSize, weight: .light)
        lastUpdatedLabel.stringValue = "更新时间：2019-04-29"
        lastUpdatedLabel.textColor = NSColor.systemGray
        addSubview(lastUpdatedLabel)
        lastUpdatedLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().offset(-50)
        }
        
        settingButton = NSButton(image: NSImage(named: "icon_setting")!, target: self, action: #selector(handleTapSettingButton(_:)))
        settingButton.bezelStyle = .texturedSquare
        settingButton.isBordered = false
        settingButton.setButtonType(.momentaryPushIn)
        addSubview(settingButton)
        settingButton.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-12)
        }
        
        wantsLayer = true
        layer?.backgroundColor = NSColor(white: 247.0/255, alpha: 1.0).cgColor
    }
    
    @objc private func handleTapSettingButton(_ sender: NSButton) {
        OpenSettingMenuAction.perform(sender)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    func update(stock: Stock) {
        lastUpdatedLabel.stringValue = "更新时间：" + stock.lastUpdatedTime
    }
    
}
