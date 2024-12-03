//
//  TopTenMarketCapTests.swift
//  TopTenMarketCapTests
//
//  Created by Swift on 02/12/24.
//

import XCTest
@testable import TopTenMarketCap

final class TopTenMarketCapTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
     }
    
    /// NetworkManager XCTests
    
    func test_NetworkManager_isConnected() {
        
        let expected_result = true
        let networkManager = NetworkManager.shared
        
        XCTAssertEqual(networkManager.isConnected, expected_result)
    }
    
    func test_NetworkMamager_isConnected_true() throws {
        
        let networkManager = NetworkManager.shared
        let expected_result = true
        let timeout = 30.0
        
        let publisher = networkManager.$isConnected.first()
        
        networkManager.isConnected = true
        
        var result: Result<Bool, Error>?
        let expectation = self.expectation(description: "Awaiting publisher")
        
        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    result = .failure(error)
                case .finished:
                    print(">> Test test_NetworkManager_isConnected_true: receiveCompletion finished <<")
                    break
                }
                print(">> Test test_NetworkManager_isConnected_true: expectation.fulfilled <<")
                expectation.fulfill()
            },
            receiveValue: { value in
                result = .success(value)
                if let result { print(">> Test test_NetworkManager_isConnected_true: receiveValue \(result)") }
             }
        )
        waitForExpectations(timeout: timeout)
        cancellable.cancel()
        
        let unwrappedResult = try XCTUnwrap(result)
        print(">> Test test_NetworkManager_isConnected_true: unwrappedResult \(unwrappedResult)")
        let isNetworkAvailable: Bool = try unwrappedResult.get()
        
        XCTAssertEqual(isNetworkAvailable, expected_result)
    }
    
    func test_NetworkManager_loadData_forURLRequest_expected_not_nil() async throws {
        
        let networkManager = NetworkManager.shared
        var pingResponse: PingModel?
        let coinGeckoApiURL = CoinGeckoApiUrl.demoCoinGeckoApiPingURL
        
        pingResponse = try await networkManager.loadData(forURLRequest: coinGeckoApiURL)
        XCTAssertNotNil(pingResponse)
    }
    
    /// DataManager XCTests

    func test_DataManager_resetData() {
        
        let expected_errorDescription: String = ""
        let expected_pingResponse: PingModel? = nil
        let expected_coinsMarketsResponse: [CoinsMarketsModel]? = nil
        let expected_coinsMarketDataModel: CoinsMarketDataModel? = nil
        let expected_coinsMarketChartModel: CoinsMarketChartModel? = nil
        
        let dataManager = DataManager.shared
        dataManager.resetData()
        
        XCTAssertEqual(dataManager.errorDescription, expected_errorDescription)
        XCTAssertEqual(dataManager.pingResponse, expected_pingResponse)
        XCTAssertEqual(dataManager.coinsMarketsResponse, expected_coinsMarketsResponse)
        XCTAssertEqual(dataManager.coinsMarketDataModel, expected_coinsMarketDataModel)
        XCTAssertEqual(dataManager.coinsMarketChartModel, expected_coinsMarketChartModel)
        
        XCTAssertNil(dataManager.coinGeckoResponse) // Any? = nil
    }
    
    // See TopTenListViewModel
    
    @MainActor
    func test_DataManager_loadDataAsync_type_ping_expected_v3() async {
        
        let expected_result = "(V3) To the Moon!"
        let dataManager = DataManager.shared
        
        await dataManager.loadDataAsync(
            urlType: .ping(coinGeckoApiURL: CoinGeckoApiUrl.demoCoinGeckoApiPingURL),
            forURLRequest: CoinGeckoApiUrl.demoCoinGeckoApiPingURL)
        
        if let coinGeckoResponse = dataManager.coinGeckoResponse as? PingModel {
            XCTAssertEqual(coinGeckoResponse.gecko_says, expected_result)
        }
    }
            
    @MainActor
    func test_DataManager_loadDataAsync_type_markets_expected_ten() async {
        
        let expected_result = 10
        let dataManager = DataManager.shared
        
        await dataManager.loadDataAsync(
            urlType: .markets(
            baseCoinGeckoApiURL: CoinGeckoApiUrl.baseCoinGeckoApiCoinsURL,
            relativeCoinGeckoApiURL: CoinGeckoApiUrl.relativeCoinGeckoMarketsWithTenMarketCapDescQueryItemsURL)
        )
        if let coinGeckoResponse = dataManager.coinGeckoResponse as? [CoinsMarketsModel] {
            XCTAssertEqual(coinGeckoResponse.count, expected_result)
        }
    }

    // See TopTenDetailsViewModel
    
    @MainActor
    func test_DataManager_loadDataAsync_type_marketChart_expected_seven_prices() async {
        
        let expected_result = 8 // week + last
        let dataManager = DataManager.shared
        let coinID = "bitcoin"
        
        await dataManager.loadDataAsync(
            urlType: .marketChart(
                baseCoinGeckoApiURL: CoinGeckoApiUrl.baseCoinGeckoApiCoinsURL,
                coinID: coinID,
                relativeCoinGeckoApiURL: CoinGeckoApiUrl.relativeCoinGeckoMarketChartWithSevenDaysQueryItemsURL)
        )
        if let coinGeckoResponse = dataManager.coinGeckoResponse as! CoinsMarketChartModel? {
            XCTAssertGreaterThan(coinGeckoResponse.prices.count, 0)
            XCTAssertEqual(coinGeckoResponse.prices.count, expected_result)
        }
    }
    
    @MainActor
    func test_DataManager_loadDataAsync_type_description_expected_description_not_empty_for_id() async {
        
        let expected_result = ""
        let dataManager = DataManager.shared
        let coinID = "bitcoin"
        
        await dataManager.loadDataAsync(
            urlType: .description(
                baseCoinGeckoApiURL: CoinGeckoApiUrl.baseCoinGeckoApiCoinsURL,
                coinID: coinID,
                relativeCoinGeckoApiURL: CoinGeckoApiUrl.relativeCoinGeckoDescriptionAndLinkWithQueryItemsURL)
        )
        if let coinGeckoResponse = dataManager.coinGeckoResponse as! CoinsMarketDataModel? {
            XCTAssertEqual(coinGeckoResponse.id, coinID)
            XCTAssertNotEqual(coinGeckoResponse.description.en, expected_result)
        }
    }

    @MainActor
    func test_DataManager_loadDataAsync_type_description_expected_link_url() async {
        
        let dataManager = DataManager.shared
        let coinID = "bitcoin"
        
        await dataManager.loadDataAsync(
            urlType: .description(
                baseCoinGeckoApiURL: CoinGeckoApiUrl.baseCoinGeckoApiCoinsURL,
                coinID: coinID,
                relativeCoinGeckoApiURL: CoinGeckoApiUrl.relativeCoinGeckoDescriptionAndLinkWithQueryItemsURL)
        )
        if let coinGeckoResponse = dataManager.coinGeckoResponse as! CoinsMarketDataModel?, let link = coinGeckoResponse.links.homepage.first {
            XCTAssertTrue(link.isURL())
        } else {
            // e.g: without network would raise failure with message
            // failed - loadDataAsync failed with error: The Internet connection appears to be offline.
            XCTFail("loadDataAsync failed with error: \(dataManager.errorDescription)")
        }
    }
    
    /// Test URL and Decode Errors
    
    // The following XCTests has been setup to run on a localized macOS, with English as primary language (en_IT), to match expected errorDescription, but can also be run on it_IT locale

    func test_current_locale() async {
        switch Locale.current.identifier {
        case "it_IT":
            XCTAssertEqual(Locale.current.identifier, "it_IT")
        case "en_IT":
            XCTAssertEqual(Locale.current.identifier, "en_IT")
        default:
            XCTFail("Current locale \(Locale.current.identifier) is not supported for CountriesTests")
        }
    }

    @MainActor
    func test_DataManager_loadDataAsync_type_description_expected_error_with_wrongURL() async {
        
        // The relativeCoinGeckoDescriptionAndLinkWithQueryItemsURL works with CoinsMarketDataModel
        // Using relativeCoinGeckoMarketChartWithSevenDaysQueryItemsURL should decode with CoinsMarketChartModel

        // en_IT, it_IT: "The data couldn’t be read because it is missing."
        let expected_result = CoinGeckoErrors.Error.missingData.errorDescription
        let dataManager = DataManager.shared
        let coinID = "bitcoin"
        var errorDescription: String = CoinGeckoErrors.Error.none.errorDescription
        
        await dataManager.loadDataAsync(
            urlType: .description(
                baseCoinGeckoApiURL: CoinGeckoApiUrl.baseCoinGeckoApiCoinsURL,
                coinID: coinID,
                relativeCoinGeckoApiURL: CoinGeckoApiUrl.relativeCoinGeckoMarketChartWithSevenDaysQueryItemsURL)
        )
        errorDescription = dataManager.errorDescription
        if let coinGeckoResponse = dataManager.coinGeckoResponse as? CoinsMarketDataModel {
            XCTAssertNotNil(coinGeckoResponse)
        }
        XCTAssertNotEqual(errorDescription, CoinGeckoErrors.Error.none.errorDescription)
        XCTAssertEqual(errorDescription, expected_result)
    }
    
    @MainActor
    func test_NetworkManager_loadData_forURLRequest_malformed_url() async throws {
        
        // en_IT, it_IT: "The resource could not be loaded because the App Transport Security policy requires the use of a secure connection."
        let expected_errorDescription = CoinGeckoErrors.Error.malformedURL.errorDescription
        let networkManager = NetworkManager.shared
        var pingResponse: PingModel?
        let coinGeckoApiMalformedURL = CoinGeckoApiUrl.demoCoinGeckoApiPingURL.replacingOccurrences(of: "https", with: "http")
        
        do {
            pingResponse = try await networkManager.loadData(forURLRequest: coinGeckoApiMalformedURL)
        } catch {
            XCTAssertNil(pingResponse)
            XCTAssertEqual(error.localizedDescription, expected_errorDescription)
        }
    }
    
    @MainActor
    func test_NetworkManager_loadData_forURLRequest_invalidFormat_url() async throws {
        
        // en_IT: "The data couldn’t be read because it isn’t in the correct format."
        // it_IT: "Impossibile leggere i dati perché non sono nel formato corretto."
        let expected_errorDescription = CoinGeckoErrors.Error.invalidFormat.errorDescription
        let networkManager = NetworkManager.shared
        var pingResponse: PingModel?
        let invalidURL = "https://google.com/"
        
        do {
            pingResponse = try await networkManager.loadData(forURLRequest: invalidURL)
        } catch {
            XCTAssertNil(pingResponse)
            XCTAssertEqual(error.localizedDescription, expected_errorDescription)
        }
    }
    
    @MainActor
    func test_NetworkManager_loadData_forURLRequest_wrongURL_ExpectFailure() async throws {
        
        // en_IT: "The data couldn’t be read because it isn’t in the correct format."
        // it_IT: "Impossibile leggere i dati perché non sono nel formato corretto."
        let expected_errorDescription = CoinGeckoErrors.Error.invalidFormat.errorDescription
        let networkManager = NetworkManager.shared
        let expected_result = 10
        var coinsMarketsResponse: [CoinsMarketsModel]? = nil
        let demoCoinGeckoApiPingURL = CoinGeckoApiUrl.demoCoinGeckoApiPingURL
        
        do {
            coinsMarketsResponse = try await networkManager.loadData(forURLRequest: demoCoinGeckoApiPingURL)
        } catch {
            XCTAssertEqual(error.localizedDescription, expected_errorDescription)
            XCTExpectFailure {
                XCTAssertEqual(coinsMarketsResponse?.count, expected_result) // ("nil") is not equal to ("Optional(10)")
                XCTFail("LoadData failed with error: \(error)") // typeMismatch(Swift.Array<Any>, Swift.DecodingError.Context(codingPath: [], debugDescription: "Expected to decode Array<Any> but found a dictionary instead."
            }
        }
    }
    
    /// Performance tests on 2,6 GHz Intel Core i7 6 core
    
    @MainActor
    func testPerformance_topTenListViewModel_pingCoinGeckoServer() throws {
        
        let topTenListViewModel = TopTenListViewModel()
        
        measure {
            let expectation = expectation(description: "Finished")
            Task {
                await topTenListViewModel.pingCoinGeckoServer()
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 1.0)
        }
        // passed (0.273 seconds)
    }
    
    @MainActor
    func testPerformance_topTenListViewModel_loadCoinGeckoMarkets() throws {
        
        let topTenListViewModel = TopTenListViewModel()

        measureMetrics([.wallClockTime], automaticallyStartMeasuring: true) {
            let expectation = expectation(description: "Finished")
            Task {
                await topTenListViewModel.loadCoinGeckoMarkets()
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 1.0)
        }
        // passed (0.272 seconds)
    }
    
    @MainActor
    func testPerformance_topTenDetailsViewModel_loadCoinGeckoMarketChartPrices() throws {
        
        let topTenDetailsViewModel = TopTenDetailsViewModel()

        measureMetrics([.wallClockTime], automaticallyStartMeasuring: true) {
            let expectation = expectation(description: "Finished")
            Task {
                await topTenDetailsViewModel.loadCoinGeckoMarketChartPrices(coinID: "bitcoin")
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 1.0)
        }
        // passed (0.274 seconds)
    }
    
    @MainActor
    func testPerformance_topTenDetailsViewModel_loadCoinGeckoMarketDataDescriptionAndLink() throws {
        
        let topTenDetailsViewModel = TopTenDetailsViewModel()

        measure {
            let expectation = expectation(description: "Finished")
            Task {
                await topTenDetailsViewModel.loadCoinGeckoMarketDataDescriptionAndLink(coinID: "bitcoin")
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 1.0)
        }
        // passed (0.274 seconds)
    }
    
}
