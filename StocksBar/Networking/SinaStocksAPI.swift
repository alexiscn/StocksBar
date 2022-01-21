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
    
    /// type 决定可以搜出来哪些数据，此处搜索 A股、B股、ETF、LOF、港股、美股，如有特殊需要自行Fork自行修改
    private let suggestionURL = "https://suggest3.sinajs.cn/suggest/type=11,12,22,23,31,41&key="
    
    /* https://n.sinaimg.cn/finance/stock/hq/src/hq-suggest.js
    {
        "11": "A 股",
        "12": "B 股",
        "13": "权证",
        "14": "期货",
        "15": "债券",
        "21": "开基",
        "22": "ETF",
        "23": "LOF",
        "24": "货基",
        "25": "QDII",
        "26": "封基",
        "31": "港股",
        "32": "窝轮",
        "33": "港指数",
        "41": "美股",
        "42": "外期",
        "81": "债券",
        "82": "债券",
        "103": "英股",
        "120": "债券",
        "111": "A股",
        "71": "外汇",
        "72": "基金", //场内基金（带市场）
        "85": "期货",//内盘期货
        "86": "期货",//外盘期货
        "87": "期货",//内盘期货连续，股指期货连续，50ETF期权
        "88": "期货",//内盘股指期货
        "73": "新三板",
        "74": "板块",
        "75": "板块", //新浪行业
        "76": "板块",//申万行业
        "77": "板块",//申万二级
        "78": "板块", //热门概念（财汇概念）
        "79": "板块",//地域板块
        "80": "板块",//证监会行业
        "101": "基金", //所有基金
        "100": "指数", //全球指数
        "102": "指数",//全部板块指数(概念、地域、行业)
        "103": "英股",
        "104": "国债", //（目前暂时是美国国债）"
        "105": "ETF", //美股ETF,国际线索组-中文站）"
        "106": "ETF", //美股ETF,国际线索组-英文站）"
        "107": "msci"
    }*/
    
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
        AF.request(url, headers: HTTPHeaders([HTTPHeader(name: "Referer", value: "https://finance.sina.com.cn/stock/")])).responseData { response in
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
                let code = components[0].replacingOccurrences(of: "var hq_str_", with: "").replacingOccurrences(of: "\n", with: "")
                let value = components[1].replacingOccurrences(of: "\"", with: "")
                if code.hasPrefix("jj"), let stock = createFundStockFromCode(code, value: value) {
                    stocks.append(stock)
                } else if code.hasPrefix("rt_hk"), let stock = createHKStockFromCode(code, value: value) {
                    stocks.append(stock)
                } else if code.hasPrefix("gb"), let stock = createGBStockFromCode(code, value: value) {
                    stocks.append(stock)
                } else if let stock = createStockFromCode(code, value: value) {
                    stocks.append(stock)
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
        let stock = Stock(code: code.replacingOccurrences(of: "rt_", with: ""))
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
    
    private func createGBStockFromCode(_ code: String, value: String) -> Stock? {
        let components = value.split(separator: ",").map { return String($0) }
        let stock = Stock(code: code)
        stock.symbol = components[0]
        stock.openPrice = Float(components[5]) ?? 0.0
        stock.lastClosedPrice = Float(components[26]) ?? 0.0
        stock.current = Float(components[1]) ?? 0.0
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
            let type = array[1]
            var code = array[3]
            let symbol = array[0]
            if type == "31" {
               code = "hk" + code
            } else if type == "41" {
                code = "gb_" + code
            }
            let stock = Stock(code: code)
            stock.isFavorited = StockDataSource.shared.contains(stock)
            stock.symbol = symbol
            stocks.append(stock)
        }
        return stocks
    }
    
}
