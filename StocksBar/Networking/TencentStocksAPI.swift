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
                let stock = Stock.parseTencentCode(codeText, value: value)
                stocks.append(stock)
            }
        }
        return stocks
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

