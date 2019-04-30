//
//  StockDataSource.swift
//  StocksBar
//
//  Created by xu.shuifeng on 2019/4/28.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation
import Cocoa
import Alamofire
import UserNotifications

class StockDataSource: NSObject {
    
    static let shared = StockDataSource()
    
    var updatedHandler: RelayCommand?
    
    private var shouldUpdateDataSource = true
    
    private var content: [Stock] = []
    
    private let api = StocksAPI()
    
    private var request: DataRequest?
    
    private override init() {
        super.init()
        if let data = try? Data(contentsOf: fileURL),
            let list = try? JSONDecoder().decode([Stock].self, from: data), list.count > 0 {
            content = list
            updatedHandler?()
        } else {
            content.append(Stock(code: "sh601933"))
            content.append(Stock(code: "sz000651"))
            content.append(Stock(code: "sz000858"))
            content.append(Stock(code: "sz002594"))
            content.append(Stock(code: "sh601318"))
            content.append(Stock(code: "sh601360"))
        }
        update()
    }
    
    func numberOfRows() -> Int {
        return content.count
    }
    
    func data(atIndex index: Int) -> Stock {
        return content[index]
    }
 
    @objc private func update() {
        if content.count == 0 {
            return
        }
        let codes = content.map { return $0.code }
        request = api.request(codes: codes) { (stocks, error) in
            if let error = error {
                print(error)
            } else {
                if self.shouldUpdateDataSource {
                    self.content = stocks
                    self.updatedHandler?()
                    if let appDelegate = NSApplication.shared.delegate as? AppDelegate {
                        appDelegate.update(stock: self.content.first)
                    }
                }
            }
            self.perform(#selector(self.update), with: nil, afterDelay: 1.0, inModes: [.default])
        }
    }
    
    private var fileURL: URL {
        let path = NSHomeDirectory().appending("/Documents/stocks.data")
        return URL(fileURLWithPath: path)
    }
    
    func save() {
        do {
            if FileManager.default.fileExists(atPath: fileURL.path) {
                try FileManager.default.removeItem(at: fileURL)
            }
            let data = try JSONEncoder().encode(content)
            try data.write(to: fileURL)
        } catch {
            print(error)
        }
    }
    
    func stickToTop(at index: Int) {
        shouldUpdateDataSource = false
        var array = content
        let stock = array.remove(at: index)
        array.insert(stock, at: 0)
        content = array
        save()
        shouldUpdateDataSource = true
    }
    
    func remove(stock: Stock) {
        shouldUpdateDataSource = false
        var array = content
        if let index = array.firstIndex(where: { $0.code == stock.code }) {
            array.remove(at: index)
            content = array
            save()
        }
        shouldUpdateDataSource = true
    }
}
