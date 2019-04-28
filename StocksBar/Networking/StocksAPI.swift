//
//  StocksAPI.swift
//  StocksBar
//
//  Created by xu.shuifeng on 2019/4/26.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation
import Alamofire

typealias StocksAPICompletion = ((_ stocks: [Stock], _ error: Error?) -> Void)

class StocksAPI {
    // 沪深
    private let aURL = "http://hq.sinajs.cn/list="
    // 美港
    private let gURL = "https://hq.sinajs.cn/list=gb_"
    
    func request(codes: [String], completion: @escaping StocksAPICompletion) {
        let code = codes.joined(separator: ",")
        let url = aURL.appending(code)
        Alamofire.request(url).responseString { response in
            if let content = response.result.value {
                let stocks = self.parseSinaResponseText(content)
                completion(stocks, nil)
            } else {
                completion([], response.error)
            }
        }
    }
    
    private func parseSinaResponseText(_ content: String) -> [Stock] {
        let stockContents = content.split(separator: ";").map { return String($0) }
        var stocks: [Stock] = []
        for stockText in stockContents {
            let compoents = stockText.split(separator: "=").map { return String($0) }
            if compoents.count == 2 {
                let codeText = compoents[0].replacingOccurrences(of: "var ", with: "")
                let value = compoents[1].replacingOccurrences(of: "\"", with: "")
                if let code = codeText.split(separator: "_").last,
                    let stock = Stock.parseSinaCode(String(code), value: value) {
                    stocks.append(stock)
                }
            }
        }
        return stocks
    }
}
