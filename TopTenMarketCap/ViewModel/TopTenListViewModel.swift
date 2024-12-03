//
//  TopTenListViewModel.swift
//  TopTenMarketCap
//
//  Created by Swift on 29/11/24.
//

import Foundation
import SwiftUI

final class TopTenListViewModel: ObservableObject, @unchecked Sendable {
    
    var dataManager: DataManager = DataManager.shared
    
    @Published var pingResponseString: String = "Waiting Ping Response"
    @Published var coinsResponseList: [CoinsMarketsModel] = []
    @Published var errorDescription: String = CoinGeckoErrors.Error.none.errorDescription
        
    func pingCoinGeckoServer() async {
        Task { @MainActor in
            await dataManager.loadDataAsync(
                urlType: .ping(coinGeckoApiURL: CoinGeckoApiUrl.demoCoinGeckoApiPingURL),
                forURLRequest: CoinGeckoApiUrl.demoCoinGeckoApiPingURL)   // TODO: togliere forURLRequest:
            errorDescription = dataManager.errorDescription
            if let pingresponse = dataManager.pingResponse, dataManager.networkManager.isConnected {
                pingResponseString = pingresponse.gecko_says
                print(">> TopTenListViewModel pingCoinGeckoServer Task: gecko_says '\(pingresponse.gecko_says)', errorDescription '\(errorDescription)' <<")
            }
        }
    }
    
    func loadCoinGeckoMarkets() async {
        Task { @MainActor in
            await dataManager.loadDataAsync(
                urlType: .markets(
                baseCoinGeckoApiURL: CoinGeckoApiUrl.baseCoinGeckoApiCoinsURL,
                relativeCoinGeckoApiURL: CoinGeckoApiUrl.relativeCoinGeckoMarketsWithTenMarketCapDescQueryItemsURL)
            )
            errorDescription = dataManager.errorDescription
            if let coinGeckoResponse = dataManager.coinGeckoResponse, dataManager.networkManager.isConnected {
                coinsResponseList = coinGeckoResponse as? [CoinsMarketsModel] ?? []
                print(">> TopTenListViewModel loadCoinGeckoMarkets Task: coinGeckoResponse '\(coinGeckoResponse)', errorDescription '\(errorDescription)' <<")
            }
        }
    }
}
