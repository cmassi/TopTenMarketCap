//
//  CoinGeckoApiUrl.swift
//  TopTenMarketCap
//
//  Created by Swift on 30/11/24.
//

import Foundation

struct CoinGeckoApiUrl {
    
    /// CoinGecko Public Demo Plan API KEY
    /// - Label: CoinGeckoDemoAPIKey
    /// - Creation Date: 2024-11-28
    /// - Usage: curl --request GET --url <URL> --header 'accept: application/json' --header 'x-cg-demo-api-key: <COINGECKO_API_KEY>'
    
    static var COINGECKO_API_KEY: String { "CG-RieJSxEo2kQNWt7jjsJiih8f" }
    
    
    /// Ping URL for CoinGecko API KEY Authentication Method to Check API server status with Header Parameter
    /// - Reference: https://docs.coingecko.com/v3.0.1/reference/ping-server
    /// - Usage: demoCoinGeckoApiPingURL
    /// - Header Item values:
    ///   - accept: application/json
    ///   - x-cg-demo-api-key: <COINGECKO_API_KEY>
    /// - Sample:  https://api.coingecko.com/api/v3/ping?x_cg_demo_api_key=COINGECKO_API_KEY
    
    static var demoCoinGeckoApiPingURL: String { "https://api.coingecko.com/api/v3/ping" }
    
    
    /// Demonstration Ping URL for CoinGecko API KEY Authentication Method to Check API server status with Query String Parameter
    /// - Reference:  https://docs.coingecko.com/v3.0.1/reference/authentication
    /// - Usage: demoCoinGeckoApiPingWithQueryItemURL+<COINGECKO_API_KEY>
    /// - Query Item values:
    ///   - x_cg_demo_api_key: <COINGECKO_API_KEY>
    /// - Sample:  https://api.coingecko.com/api/v3/ping?x_cg_demo_api_key=COINGECKO_API_KEY
    
    static var demoCoinGeckoApiPingWithQueryItemURL: String { "https://api.coingecko.com/api/v3/ping?x_cg_demo_api_key=" }
    
    
    /// Base CoinGecko URL of API Coins to retrieve current info
    /// - Reference: https://docs.coingecko.com/v3.0.1/reference
    /// - Usage: baseCoinGeckoApiCoinsURL+[<coinID>]+relativeCoinGecko*URL
    
    static var baseCoinGeckoApiCoinsURL: String { "https://api.coingecko.com/api/v3/coins/" }
    
    
    /// Relative CoinGecko URL to retrieve "name", "image", "current_price" in market top10 coins for main view
    /// - Reference: https://api.coingecko.com/api/v3/coins/markets
    /// - Usage: baseCoinGeckoApiCoinsURL+relativeCoinGeckoMarketsWithTenMarketCapDescQueryItemsURL
    /// - Query Item values:
    ///   - vs_currency: eur
    ///   - order: market_cap_desc
    ///   - per_page: 10
    ///   - locale: it
    /// - Sample: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=eur&order=market_cap_desc&per_page=10&locale=it"
    
    static var relativeCoinGeckoMarketsWithTenMarketCapDescQueryItemsURL: String { "markets?vs_currency=eur&order=market_cap_desc&per_page=10&locale=it" }
    
    
    /// Relative CoinGecko URL to retrieve "description" and "links":"homepage" for details view
    /// - Reference: https://docs.coingecko.com/v3.0.1/reference/coins-id
    /// - Usage: baseCoinGeckoApiCoinsURL+<coinID>+relativeCoinGeckoDescriptionAndLinkWithQueryItemsURL
    /// - Query Item values:
    ///   - localization: it
    ///   - tickers: false
    ///   - market_data: false
    ///   - community_data: false
    ///   - developer_data: false
    ///   - sparkline: false
    /// - Sample: https://api.coingecko.com/api/v3/coins/bitcoin?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false
    
    static var relativeCoinGeckoDescriptionAndLinkWithQueryItemsURL: String { "?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false" }
    
    
    /// Relative CoinGecko URL to retrieve coinID "prices" for details view
    /// - Usage: baseCoinGeckoApiCoinsURL+<coinID>+marketChartRelativeWithSevenDaysQueryURL
    /// - Reference: https://docs.coingecko.com/v3.0.1/reference/coins-id-market-chart
    /// - Query Item values:
    ///   - vs_currency: eur
    ///   - days: 7
    ///   - interval: daily
    /// - Sample: https://api.coingecko.com/api/v3/coins/bitcoin/market_chart?vs_currency=eur&days=7&interval=daily
    
    static var relativeCoinGeckoMarketChartWithSevenDaysQueryItemsURL: String { "/market_chart?vs_currency=eur&days=7&interval=daily" }
    
    
}
