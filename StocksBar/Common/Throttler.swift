//
//  Throttler.swift
//  StocksBar
//
//  Created by xushuifeng on 2019/5/1.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation

private extension Date {
    static func second(from referenceDate: Date) -> Float {
        return Float(Date().timeIntervalSince(referenceDate))
    }
}

class Throttler {
    
    private let queue: DispatchQueue = DispatchQueue.global(qos: .background)
    private var job: DispatchWorkItem = DispatchWorkItem(block: {})
    private var previousRun: Date = Date.distantPast
    private var maxInterval: Float
    
    init(seconds: Float) {
        self.maxInterval = seconds
    }
    
    func throttle(block: @escaping () -> ()) {
        job.cancel()
        job = DispatchWorkItem() { [weak self] in
            self?.previousRun = Date()
            block()
        }
        let delay = Date.second(from: previousRun) > maxInterval ? 0 : maxInterval
        queue.asyncAfter(deadline: .now() + Double(delay), execute: job)
    }
    
}
