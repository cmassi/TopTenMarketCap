//
//  CoinsMarketDataLinksModel.swift
//  TopTenMarketCap
//
//  Created by Swift on 30/11/24.
//

import Foundation

struct CoinsMarketDataLinksModel: Hashable, Codable {
    var homepage: [String]
    
    init(homepage: [String] = []) {
        self.homepage = homepage
    }
}
