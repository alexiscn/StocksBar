//
//  TencentStocksAPI.swift
//  StocksBar
//
//  Created by xu.shuifeng on 2020/7/3.
//  Copyright © 2020 alexiscn. All rights reserved.
//

import Foundation
import Alamofire

class TencentStocksAPI {
    
    private let aURL = "https://qt.gtimg.cn/q="
    
    private let suggestionURL = "https://smartbox.gtimg.cn/s3/?v=2&t=all&q="
    
    func request(codes: [String], completion: @escaping StocksAPICompletion) {
        let code = codes.joined(separator: ",")
        let url = aURL.appending(code)
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                let content = String(gbkData: data)
                let stocks = self.parseResponeText(content)
                completion(stocks, nil)
            case .failure(let error):
                debugPrint(error)
                completion([], error)
            }
        }
    }

    func suggestion(key: String, completion: @escaping StocksAPICompletion) {
        let urlString = self.suggestionURL.appending(key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        AF.request(urlString!).responseData { response in
            switch response.result {
            case .success(let data):
                let content = String(gbkData: data)?.unicodeString
                let stocks = self.parseSuggestionString(content)
                completion(stocks, nil)
            case .failure(let error):
                debugPrint(error)
                completion([], error)
            }
        }
    }

}

extension TencentStocksAPI {
    
    private func parseResponeText(_ content: String?) -> [Stock] {
        guard let content = content else { return [] }
        let stockContents = content.split(separator: ";").map { String($0) }
        var stocks: [Stock] = []
        for stockText in stockContents {
            let compoents = stockText.split(separator: "=").map { String($0) }
            if compoents.count == 2 {
                let codeText = compoents[0].replacingOccurrences(of: "v_", with: "")
                    .replacingOccurrences(of: " ", with: "")
                    .replacingOccurrences(of: "\n", with: "")
                let value = compoents[1].replacingOccurrences(of: "\"", with: "")
                let stock: Stock
                if codeText.hasPrefix("jj") {
                    stock = createFundStock(code: codeText, value: value)
                } else {
                    stock = createStockFromCode(codeText, value: value)
                }
                stocks.append(stock)
            }
        }
        return stocks
    }
    
    private func createStockFromCode(_ code: String, value: String) -> Stock {
        let stock = Stock(code: code)
        let components = value.split(separator: "~").map { String($0) }
        stock.symbol = components[1]
        stock.openPrice = Float(components[5]) ?? 0.0
        stock.lastClosedPrice = Float(components[4]) ?? 0.0
        stock.current = Float(components[3]) ?? stock.lastClosedPrice
        let time = components[29]
        if time.count == 14 {
            stock.lastUpdatedDate = String(time[time.startIndex..<time.index(time.startIndex, offsetBy: 8)])
            
            var timeText = String(time[time.index(time.startIndex, offsetBy: 8)..<time.endIndex])
            timeText.insert(":", at: timeText.index(timeText.startIndex, offsetBy: 2))
            timeText.insert(":", at: timeText.index(timeText.endIndex, offsetBy: -2))
            stock.lastUpdatedTime = timeText
        }
        return stock
    }
    
    /// 基金
    /// 110003~易方达上证50指数A~2.1723~0.8449~2020-07-13 14:19:00~2.1541~4.0541~-1.2922~2020-07-10~
    private func createFundStock(code: String, value: String) -> Stock {
        let stock = Stock(code: code)
        let components = value.split(separator: "~").map { String($0) }
        stock.symbol = components[1]
        stock.current = Float(components[2]) ?? 0.0
        //stock.percent = Float(components[3]) ?? 0.0
        let time = components[4]
        if time.contains(" ") {
            let timeArray = time.split(separator: " ").map { String($0) }
            stock.lastUpdatedDate = timeArray[0]
            stock.lastUpdatedTime = timeArray[1]
        }
        stock.lastClosedPrice = Float(components[5]) ?? 0.0
        return stock
    }
    
    private func parseSuggestionString(_ content: String?) -> [Stock] {
        guard let content = content else {
            return []
        }
        let value = content.replacingOccurrences(of: "v_hint=", with: "")
            .replacingOccurrences(of: "\"", with: "")
        if value == "N;" {
            return []
        }
        let components = value.split(separator: "^").map { String($0) }
        var stocks: [Stock] = []
        for item in components {
            let array = item.split(separator: "~").map { String($0) }
            let market = array[0]
            let code = market + array[1]
            let stock = Stock(code: code)
            stock.isFavorited = StockDataSource.shared.contains(stock)
            stock.symbol = array[2]
            stocks.append(stock)
        }
        return stocks
    }
}

