//
//  StockHeaderView.swift
//  StocksBar
//
//  Created by xu.shuifeng on 2019/4/28.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Cocoa

class StockHeaderView: NSView {

    var headerCommand: RelayCommand?
    
    private var searchField: NSSearchField!
    
    private var listButton: NSButton!
    
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
        searchField.focusRingType = .none
        searchField.placeholderString = "Search Stock"
        searchField.refusesFirstResponder = true
        addSubview(searchField)
        searchField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(28)
            make.trailing.equalToSuperview().offset(-50)
        }
                
        listButton = NSButton(image: NSImage(named: "icon_list")!, target: self, action: #selector(handleTapListButton(_:)))
        listButton.isBordered = false
        
        listButton.setButtonType(.momentaryPushIn)
        listButton.refusesFirstResponder = true
        addSubview(listButton)
        listButton.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-12)
        }
        
        wantsLayer = true
        layer?.backgroundColor = NSColor(white: 247.0/255, alpha: 1.0).cgColor
    }
    
    @objc private func handleTapListButton(_ sender: Any) {
        headerCommand?()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
