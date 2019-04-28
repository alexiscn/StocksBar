//
//  StockHeaderView.swift
//  StocksBar
//
//  Created by xu.shuifeng on 2019/4/28.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Cocoa

class StockHeaderView: NSView {

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
        addButton = NSButton(image: NSImage(named: "icon_add")!, target: self, action: #selector(handleTapAddButton(_:)))
        addButton.bezelStyle = .texturedSquare
        addButton.isBordered = false
        addButton.setButtonType(.momentaryPushIn)
        addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-12)
        }
    }
    
    @objc private func handleTapAddButton(_ sender: Any) {
        
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
