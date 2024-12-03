//
//  CoinsMarketDataDescriptionModel.swift
//  TopTenMarketCap
//
//  Created by Swift on 30/11/24.
//

import Foundation

struct CoinsMarketDataDescriptionModel: Hashable, Codable {
    var en: String
    
    init(en: String = "") {
        self.en = en
    }
}
