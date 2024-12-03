//
//  CoinsMarketChartModel.swift
//  TopTenMarketCap
//
//  Created by Swift on 30/11/24.
//

import Foundation

struct CoinsMarketChartModel: Hashable, Codable {
    var prices: [[Double]]
    
    init(prices: [[Double]] = [[]]) {
        self.prices = prices
    }
}
