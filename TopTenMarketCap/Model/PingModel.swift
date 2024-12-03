//
//  PingModel.swift
//  TopTenMarketCap
//
//  Created by Swift on 29/11/24.
//

import Foundation

struct PingModel: Hashable, Codable {
    var gecko_says: String

    init (gecko_says: String) {
        self.gecko_says = gecko_says
    }
}
