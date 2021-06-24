//
//  SinaStocksAPI.swift
//  StocksBar
//
//  Created by xu.shuifeng on 2020/7/3.
//  Copyright © 2020 alexiscn. All rights reserved.
//

import Foundation
import Alamofire

class SinaStocksAPI: StocksAPI {
    // 沪深
    private let aURL = "http://hq.sinajs.cn/list="
    
    private let suggestionURL = "https://suggest3.sinajs.cn/suggest/type=2&key="
    
    func request(codes: [String], completion: @escaping StocksAPICompletion) {
        
        let mappedCodes = codes.map { code -> String in
            if code.hasPrefix("hk") {
                return "rt_" + code
            } else {
                return code
            }
        }
        let code = mappedCodes.joined(separator: ",")
        let url = aURL.appending(code)
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                //let content = String(data: data, encoding: .utf8)
                let content = String(gbkData: data) ?? ""
                let stocks = self.parseCodeResponseText(content)
                completion(stocks, nil)
            case .failure(let error):
                debugPrint(error)
                completion([], error)
            }
        }
    }
    func suggestion(key: String, completion: @escaping StocksAPICompletion) {
        let urlString = self.suggestionURL.appending(key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        AF.request(urlString).responseData { response in
            switch response.result {
            case .success(let data):
                let content = String(gbkData: data) ?? ""
                let stocks =  self.parseSuggestionString(content)
                completion(stocks, nil)
            case .failure(let error):
                print(error)
                completion([], error)
            }
        }
    }
}

extension SinaStocksAPI {
    
    private func parseCodeResponseText(_ content: String?) -> [Stock] {
        guard let content = content else { return [] }
        let stockContents = content.split(separator: ";").map { return String($0) }
        var stocks: [Stock] = []
        for stockText in stockContents {
            let components = stockText.split(separator: "=").map { return String($0) }
            if components.count == 2 {
                let codeText = components[0].replacingOccurrences(of: "var ", with: "")
                let value = components[1].replacingOccurrences(of: "\"", with: "")
                if let last = codeText.split(separator: "_").last {
                    let code = String(last)
                    if code.hasPrefix("jj"), let stock = createFundStockFromCode(code, value: value) {
                        stocks.append(stock)
                    } else if code.hasPrefix("hk"), let stock = createHKStockFromCode(code, value: value) {
                        stocks.append(stock)
                    } else if let stock = createStockFromCode(code, value: value) {
                        stocks.append(stock)
                    }
                    
                }
            }
        }
        return stocks
    }
    
    private func createFundStockFromCode(_ code: String, value: String) -> Stock? {
        return nil
    }
    
    private func createStockFromCode(_ code: String, value: String) -> Stock? {
        let components = value.split(separator: ",").map { return String($0) }
        if components.count == 0 { return nil }
        let stock = Stock(code: code)
        stock.symbol = components[0]
        stock.openPrice = Float(components[1]) ?? 0.0
        stock.lastClosedPrice = Float(components[2]) ?? 0.0
        stock.current = Float(components[3]) ?? stock.lastClosedPrice
        if components.count >= 32 {
            stock.lastUpdatedDate = components[30]
            stock.lastUpdatedTime = components[31]
        }
        return stock
    }
    
    private func createHKStockFromCode(_ code: String, value: String) -> Stock? {
        let components = value.split(separator: ",").map { return String($0) }
        let stock = Stock(code: code)
        stock.symbol = components[1]
        stock.openPrice = Float(components[2]) ?? 0.0
        stock.lastClosedPrice = Float(components[3]) ?? 0.0
        stock.current = Float(components[6]) ?? stock.lastClosedPrice
        if components.count >= 32 {
            stock.lastUpdatedDate = components[17]
            stock.lastUpdatedTime = components[18]
        }
        return stock
    }
    
    private func parseSuggestionString(_ content: String?) -> [Stock] {
        guard let content = content else {
            return []
        }
        let value = content.replacingOccurrences(of: "var suggestvalue=", with: "")
            .replacingOccurrences(of: "\"", with: "")
        let _ = value.dropLast()
        let components = value.split(separator: ";").map { return String($0) }
        var stocks: [Stock] = []
        for item in components {
            let array = item.split(separator: ",").map { return String($0) }
            let stock = Stock(code: array[0])
            stock.isFavorited = StockDataSource.shared.contains(stock)
            stock.symbol = array[4]
            stocks.append(stock)
        }
        return stocks
    }
    
}
