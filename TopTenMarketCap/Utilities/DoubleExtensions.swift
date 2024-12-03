//
//  DoubleExtensions.swift
//  TopTenMarketCap
//
//  Created by Swift on 01/12/24.
//

import Foundation

extension Double {
    
    var int: Int {
        return Int(Darwin.round(self))
    }
    
    var intString: String {
        return String(format: "%.0f", self)
    }
    
    var priceString: String {
        return String(format: "%.6f", self)
    }
    
    var timeIntervalToShortDateNoTime: String {
        return Date(timeIntervalSince1970: TimeInterval(self/1000)).formatted(date: .abbreviated, time: .omitted)
    }
    
    var timeIntervalToShortDateAndTime: String {
        return Date(timeIntervalSince1970: TimeInterval(self/1000)).formatted(date: .abbreviated, time: .shortened)
    }
}
