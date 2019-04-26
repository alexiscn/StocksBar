//
//  StockTableViewCell.swift
//  StocksBar
//
//  Created by xu.shuifeng on 2019/4/26.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AppKit
import SnapKit

class StockTableViewCell: NSTableCellView {
    
    private let symbolLabel: NSTextField
    
    private let priceLabel: NSTextField
    
    override init(frame frameRect: NSRect) {
        
        symbolLabel = NSTextField()
        
        priceLabel = NSTextField()
        
        super.init(frame: frameRect)
        
        addSubview(symbolLabel)
        addSubview(priceLabel)
        
        symbolLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
