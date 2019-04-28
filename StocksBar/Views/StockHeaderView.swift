//
//  StockHeaderView.swift
//  StocksBar
//
//  Created by xu.shuifeng on 2019/4/28.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Cocoa

class StockHeaderView: NSView {

    var addCommand: RelayCommand?
    
    private var searchField: NSSearchField!
    
//    private var titleLabel: NSTextField!
    
    private var addButton: NSButton!
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        commonInit()
    }
    
    private func commonInit() {
        
        searchField = NSSearchField()
        searchField.placeholderString = "Search Stock"
        searchField.refusesFirstResponder = true
        addSubview(searchField)
        searchField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().offset(-50)
        }
        
//        titleLabel = NSTextField()
//        titleLabel.isBordered = false
//        titleLabel.backgroundColor = .clear
//        titleLabel.isEditable = false
//        titleLabel.alignment = .center
//        titleLabel.font = NSFont.systemFont(ofSize: NSFont.systemFontSize, weight: .light)
//        titleLabel.stringValue = "StocksBar"
//        titleLabel.textColor = NSColor.headerColor
//        addSubview(titleLabel)
//        titleLabel.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.centerY.equalToSuperview()
//            make.leading.equalToSuperview().offset(50)
//            make.trailing.equalToSuperview().offset(-50)
//        }
        
        addButton = NSButton(image: NSImage(named: "icon_add")!, target: self, action: #selector(handleTapAddButton(_:)))
        addButton.isBordered = false
        addButton.setButtonType(.momentaryPushIn)
        addButton.refusesFirstResponder = true
        addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-12)
        }
    }
    
    @objc private func handleTapAddButton(_ sender: Any) {
        addCommand?()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
