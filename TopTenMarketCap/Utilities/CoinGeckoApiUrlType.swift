//
//  CoinGeckoApiUrlType.swift
//  TopTenMarketCap
//
//  Created by Swift on 30/11/24.
//

import Foundation

enum CoinGeckoApiUrlType {
    // Usage: demoCoinGeckoApiPingURL
    case ping(coinGeckoApiURL: String)
    // Usage: baseCoinGeckoApiCoinsURL+relativeCoinGeckoMarketsWithTenMarketCapDescQueryItemsURL
    case markets(baseCoinGeckoApiURL: String, relativeCoinGeckoApiURL: String)
    // Usage: baseCoinGeckoApiCoinsURL+<coinID>+relativeCoinGeckoDescriptionAndLinkWithQueryItemsURL
    case description(baseCoinGeckoApiURL: String, coinID: String, relativeCoinGeckoApiURL: String)
    // Usage: baseCoinGeckoApiCoinsURL+<coinID>+marketChartRelativeWithSevenDaysQueryURL
    case marketChart(baseCoinGeckoApiURL: String, coinID: String, relativeCoinGeckoApiURL: String)
}
