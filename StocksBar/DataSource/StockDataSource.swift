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
    
    private var content: [Stock] = []
    
    private let api = SinaStocksAPI()
    
    private var currentIndex = 0
    
    private var fileURL: URL {
        let name: String
        #if DEBUG
            name = "stocks_debug.data"
        #else
            name = "stocks.data"
        #endif
        let path = NSHomeDirectory().appending("/Documents/\(name)")
        print(path)
        return URL(fileURLWithPath: path)
    }
    
    private var appDelegate: AppDelegate? {
        return NSApplication.shared.delegate as? AppDelegate
    }
    
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
            save()
        }
        update()
    }
    
    // MARK: - Public functions
    
    func numberOfRows() -> Int {
        return content.count
    }
    
    func data(atIndex index: Int) -> Stock {
        return content[index]
    }
    
    func add(stock: Stock) {
        var array = content
        if !array.contains(where: { $0.code == stock.code }) {
            array.insert(stock, at: 0)
            content = array
            save()
            updatedHandler?()
        }
    }
    
    func remove(stock: Stock) {
        var array = content
        if let index = array.firstIndex(where: { $0.code == stock.code }) {
            array.remove(at: index)
            content = array
            save()
        }
    }
    
    func remove(at index: Int) {
        var array = content
        array.remove(at: index)
        content = array
        save()
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
        var array = content
        let stock = array.remove(at: index)
        array.insert(stock, at: 0)
        content = array
        save()
    }
    
    func updateReminderOfStock(_ newStock: Stock) {
        if let stock = content.first(where: { $0.code == newStock.code }) {
            stock.reminder = newStock.reminder
            save()
        }
    }
    
    func contains(_ stock: Stock) -> Bool {
        return content.contains(where: { $0.code == stock.code })
    }
    
    func move(from index: Int, to row: Int) {
        var array = content
        array.insert(array.remove(at: index), at: row)
        content = array
        save()
        updatedHandler?()
    }
    
    func search(suggestion: String, completion: @escaping StocksAPICompletion) {
        api.suggestion(key: suggestion, completion: completion)
    }
    
    // MARK: - Private functions
    
    @objc private func update() {
        if content.count == 0 {
            return
        }
        let codes = content.map { return $0.code }
        api.request(codes: codes) { (stocks, error) in
            if let error = error {
                print(error)
            } else {
                self.updateStocks(stocks)
                self.updatedHandler?()
                self.updateStatusBar()
            }
            let time = AppPreferences.shared.refreshInterval
            self.perform(#selector(self.update), with: nil, afterDelay: TimeInterval(time), inModes: [.default])
        }
    }
    
    private func updateStocks(_ newStocks: [Stock]) {
        for stock in content {
            if let n = newStocks.first(where: { $0.code == stock.code }) {
                stock.update(with: n)
            }
            checkRemind(stock: stock)
        }
    }
    
    private func checkRemind(stock: Stock) {
        if stock.reminder.checkRemind(percent: stock.percent, price: stock.current) {
            stock.reminder.toasted = true
            stock.reminder.toastDate = Date()
            save()
            
            let price = String(format: "%.2f", stock.current)
            
            let notification = NSUserNotification()
            notification.title = "股价提醒"
            notification.subtitle = "你关注的\(stock.symbol) 达到\(price)"
            notification.informativeText = stock.reminder.remindText(percent: stock.percent, price: stock.current)
            notification.deliveryDate = Date(timeInterval: 0.5, since: Date())
            NSUserNotificationCenter.default.scheduleNotification(notification)
        }
    }
    
    private func updateStatusBar() {
        if AppPreferences.shared.loopDisplayStocks {
            currentIndex = currentIndex % content.count
            appDelegate?.update(stock: content[currentIndex])
            currentIndex += 1
        } else {
            appDelegate?.update(stock: content.first)
        }
    }
}
