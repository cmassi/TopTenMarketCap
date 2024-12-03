//
//  TopTenDetailsViewModel.swift
//  TopTenMarketCap
//
//  Created by Swift on 30/11/24.
//

import Foundation

import SwiftUI

@Observable
final class TopTenDetailsViewModel {
    
    var dataManager: DataManager = DataManager.shared
    
    var coinsResponseDescription: CoinsMarketDataModel = CoinsMarketDataModel()
    var coinsResponsePrices: CoinsMarketChartModel = CoinsMarketChartModel()
    var errorDescription: String = CoinGeckoErrors.Error.none.errorDescription
    
    func loadCoinGeckoMarketDataDescriptionAndLink(coinID: String) async {
        Task { @MainActor in
            await dataManager.loadDataAsync(
                urlType: .description(
                    baseCoinGeckoApiURL: CoinGeckoApiUrl.baseCoinGeckoApiCoinsURL,
                    coinID: coinID,
                    relativeCoinGeckoApiURL: CoinGeckoApiUrl.relativeCoinGeckoDescriptionAndLinkWithQueryItemsURL)
            )
            errorDescription = dataManager.errorDescription
            if let coinGeckoResponse = dataManager.coinGeckoResponse, dataManager.networkManager.isConnected {
                coinsResponseDescription = coinGeckoResponse as? CoinsMarketDataModel ?? CoinsMarketDataModel()
                print(">> TopTenListViewModel loadCoinGeckoDescriptionAndLink Task: coinGeckoResponse '\(coinGeckoResponse)', errorDescription '\(errorDescription)' <<")
            }
        }
    }
    
    func getDescription(sleep milliseconds: UInt64 = 500) async throws -> String? {
        // print("load : \(Thread.current)") // Only for Debug
        try await Task.sleep(for: .milliseconds(milliseconds)) // or .seconds(milliseconds*1000)
        return coinsResponseDescription.description.en
    }
    
    func getLink(sleep secs: UInt64 = 1) async throws -> String? {
        // print("load : \(Thread.current)") // Only for Debug
        try await Task.sleep(nanoseconds: secs*1000*1000*1000)    // default 1_000_000_000
        return coinsResponseDescription.links.homepage.first
    }
    
    func loadCoinGeckoMarketChartPrices(coinID: String) async {
        Task { @MainActor in
            await dataManager.loadDataAsync(
                urlType: .marketChart(
                    baseCoinGeckoApiURL: CoinGeckoApiUrl.baseCoinGeckoApiCoinsURL,
                    coinID: coinID,
                    relativeCoinGeckoApiURL: CoinGeckoApiUrl.relativeCoinGeckoMarketChartWithSevenDaysQueryItemsURL)
            )
            errorDescription = dataManager.errorDescription
            if let coinGeckoResponse = dataManager.coinGeckoResponse, dataManager.networkManager.isConnected {
                coinsResponsePrices = coinGeckoResponse as? CoinsMarketChartModel ?? CoinsMarketChartModel()
                print(">> TopTenListViewModel loadCoinGeckoMarketChartPrices Task: 􀙇 coinGeckoResponse '\(coinGeckoResponse)', errorDescription '\(errorDescription)' <<")
            } else {
                print(">> TopTenListViewModel loadCoinGeckoMarketChartPrices Task: 􀙥 No connection or no response, errorDescription '\(errorDescription)' <<")
            }
        }
    }
}
