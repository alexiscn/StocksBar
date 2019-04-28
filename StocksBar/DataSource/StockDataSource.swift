//
//  StockDataSource.swift
//  StocksBar
//
//  Created by xu.shuifeng on 2019/4/28.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation
import Cocoa

class StockDataSource: NSObject {
    
    static let shared = StockDataSource()
    
    var updatedHandler: RelayCommand?
    
    var stop = false
    
    private var content: [Stock] = []
    
    private let api = StocksAPI()
    
    func load() {
        content.append(Stock(code: "sh601933"))
        content.append(Stock(code: "sz000651"))
        content.append(Stock(code: "sz000858"))
        content.append(Stock(code: "sz002594"))
        content.append(Stock(code: "sh601318"))
        update()
    }
    
    func numberOfRows() -> Int {
        return content.count
    }
    
    func data(atIndex index: Int) -> Stock {
        return content[index]
    }
 
    @objc func update() {
        let codes = content.map { return $0.code }
        api.request(codes: codes) { (stocks, error) in
            if let error = error {
                print(error)
            } else {
                self.content = stocks
                self.updatedHandler?()
                if !self.stop {
                    self.perform(#selector(self.update), with: nil, afterDelay: 1.0, inModes: [.default])
                }
                if let appDelegate = NSApplication.shared.delegate as? AppDelegate {
                    appDelegate.update(stock: self.content.first)
                }
            }
        }
    }
}
