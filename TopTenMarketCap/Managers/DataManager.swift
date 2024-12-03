//
//  DataManager.swift
//  TopTenMarketCap
//
//  Created by Swift on 29/11/24.
//

import Foundation

final class DataManager: ObservableObject, @unchecked Sendable {
    
    static let shared = DataManager()
    let networkManager = NetworkManager.shared

    @Published var errorDescription = ""
    @Published var pingResponse: PingModel?
    @Published var coinsMarketsResponse: [CoinsMarketsModel]?
    @Published var coinsMarketDataModel: CoinsMarketDataModel?
    @Published var coinsMarketChartModel: CoinsMarketChartModel?
    @Published var coinGeckoResponse: Any?
    
    private init() {
    }
        
    func loadDataAsync(urlType: CoinGeckoApiUrlType, forURLRequest: String = "") async {
        
        do {
            switch urlType {
            case .ping(let coinGeckoApiURL):
                pingResponse = try await networkManager.loadData(forURLRequest: coinGeckoApiURL)
                coinGeckoResponse = pingResponse
            case .markets(let baseCoinGeckoApiURL, let relativeCoinGeckoApiURL):
                coinsMarketsResponse = try await networkManager.loadData(forURLRequest: baseCoinGeckoApiURL+relativeCoinGeckoApiURL)
                coinGeckoResponse = coinsMarketsResponse
            case .description(let baseCoinGeckoApiURL, let coinID, let relativeCoinGeckoApiURL):
                coinsMarketDataModel = try await networkManager.loadData(forURLRequest: baseCoinGeckoApiURL+coinID+relativeCoinGeckoApiURL)
                coinGeckoResponse = coinsMarketDataModel
            case .marketChart(let baseCoinGeckoApiURL, let coinID, let relativeCoinGeckoApiURL):
                coinsMarketChartModel = try await networkManager.loadData(forURLRequest: baseCoinGeckoApiURL+coinID+relativeCoinGeckoApiURL)
                coinGeckoResponse = coinsMarketChartModel
            }
            
            if let coinGeckoResponse {
                errorDescription = CoinGeckoErrors.Error.none.errorDescription
                print(">> DataManager loadDataAsync: response \(coinGeckoResponse), error \(errorDescription)  <<")
            } else {
                errorDescription = CoinGeckoErrors.Error.invalidFormat.errorDescription
                print(">> DataManager loadDataAsync: pingResponse, error '\(errorDescription)' ")
            }
        } catch {
            errorDescription = error.localizedDescription
            print(">> DataManager loadDataAsync: error '\(error.localizedDescription)' <<")
        }
    }
    
    func resetData() {
        errorDescription = ""
        pingResponse = nil
        coinsMarketsResponse = nil
        coinsMarketDataModel = nil
        coinsMarketChartModel = nil
        coinGeckoResponse = nil
    }
}
