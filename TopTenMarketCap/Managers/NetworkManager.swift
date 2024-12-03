//
//  NetworkManager.swift
//  TopTenMarketCap
//
//  Created by Swift on 29/11/24.
//

import Network
import Foundation

class NetworkManager: ObservableObject, @unchecked Sendable {
    
    static let shared = NetworkManager()
    var urlSession = URLSession.shared
    var decoder = JSONDecoder()
    
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "NetworkMonitorQueue")
    @Published var isConnected = false

    private init() {
        networkMonitor.pathUpdateHandler = { path in
            Task { @MainActor in
                self.isConnected = path.status == .satisfied
            }
        }
        networkMonitor.start(queue: workerQueue)
    }
    
    func loadData<T: Codable>(forURLRequest: String) async throws -> T? {
        guard let url = URL(string: forURLRequest) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue(CoinGeckoApiUrl.COINGECKO_API_KEY, forHTTPHeaderField: "x-cg-demo-api-key")

        let (data, response) = try await URLSession.shared.data(for: request)
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print(">> NetworkManager loadData: for Request URL \(forURLRequest) -> response \(httpResponse.statusCode) <<")
        }
        return try decoder.decode(T.self, from: data)
    }
    
}
