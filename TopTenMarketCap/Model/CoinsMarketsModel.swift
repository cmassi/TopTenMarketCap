//
//  CoinsMarketsModel.swift
//  TopTenMarketCap
//
//  Created by Swift on 29/11/24.
//

import Foundation

struct CoinsMarketsModel: Hashable, Codable, Identifiable {
    var id: String
    var name: String
    var image: String
    var current_price: Double
    var market_cap: Int
    var market_cap_rank: Int
    var symbol: String
    
    init(id: String, name: String, image: String, current_price: Double, market_cap: Int, market_cap_rank: Int, symbol: String) {
        self.id = id
        self.name = name
        self.image = image
        self.current_price = current_price
        self.market_cap = market_cap
        self.market_cap_rank = market_cap_rank
        self.symbol = symbol
    }
}
