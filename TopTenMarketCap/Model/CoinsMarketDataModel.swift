//
//  CoinsMarketDataModel.swift
//  TopTenMarketCap
//
//  Created by Swift on 30/11/24.
//

import Foundation

struct CoinsMarketDataModel: Hashable, Codable {
    var id: String
    var symbol: String
    var name: String
    var description: CoinsMarketDataDescriptionModel
    var links: CoinsMarketDataLinksModel
    
    init(id: String = "", symbol: String = "", name: String = "", description: CoinsMarketDataDescriptionModel = CoinsMarketDataDescriptionModel(), links: CoinsMarketDataLinksModel = CoinsMarketDataLinksModel()) {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.description = description
        self.links = links
    }
}
