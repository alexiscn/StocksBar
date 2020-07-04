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
    
    private let suggestionURL = "https://suggest3.sinajs.cn/suggest/type=&key="
    
    func request(codes: [String], completion: @escaping StocksAPICompletion) {
        let code = codes.joined(separator: ",")
        let url = aURL.appending(code)
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                let content = String(data: data, encoding: .utf8)
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
                let content = String(data: data, encoding: .utf8)
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
            let compoents = stockText.split(separator: "=").map { return String($0) }
            if compoents.count == 2 {
                let codeText = compoents[0].replacingOccurrences(of: "var ", with: "")
                let value = compoents[1].replacingOccurrences(of: "\"", with: "")
                if let code = codeText.split(separator: "_").last,
                    let stock = createStockFromCode(String(code), value: value) {
                    stocks.append(stock)
                }
            }
        }
        return stocks
    }
    
    private func createStockFromCode(_ code: String, value: String) -> Stock? {
        let components = value.split(separator: ",").map { return String($0) }
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
            let stock = Stock(code: array[3])
            stock.isFavorited = StockDataSource.shared.contains(stock)
            stock.symbol = array[0]
            stocks.append(stock)
        }
        return stocks
    }
    
}
