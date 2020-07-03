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

protocol StocksAPI {
    
    func request(codes: [String], completion: @escaping StocksAPICompletion)
    
    func suggestion(key: String, completion: @escaping StocksAPICompletion)
}
