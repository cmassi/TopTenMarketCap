//
//  TopTenDetailsView.swift
//  TopTenMarketCap
//
//  Created by Swift on 30/11/24.
//

import SwiftUI

struct TopTenDetailsView: View {
    
    @EnvironmentObject private var navigationCoordinator: NavigationCoordinator
    var topTenDetailsViewModel = TopTenDetailsViewModel()   // Observable

    @State var coinID: String
    
    var homepageLink: String { topTenDetailsViewModel.coinsResponseDescription.links.homepage.first ?? "" }
    var coinAttributedDescription: AttributedString {
        AttributedString(topTenDetailsViewModel.coinsResponseDescription.description.en)
    }
    
    @State var coinDescription = ""
    @State var coinsDescriptionUnavailableOpacity: Double = 0

    var lastPrice: Double { topTenDetailsViewModel.coinsResponsePrices.prices.last?.last ?? 0 }
    var startPrice: Double { topTenDetailsViewModel.coinsResponsePrices.prices.first?.last ?? 0 }
    
    var body: some View {
        VStack {
            
            HStack {
                Spacer()
                Text(coinID.capitalized)
                    .font(.system(.largeTitle, design: .serif))
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .padding()
                if lastPrice != 0 {
                    if lastPrice > startPrice {
                        Image(systemName: "arrow.up")
                            .fontWeight(.light)
                            .foregroundStyle(.green)
                    } else if lastPrice < startPrice {
                        Image(systemName: "arrow.down")
                            .fontWeight(.light)
                            .foregroundStyle(.red)
                    }
                }
                Spacer()
            }
            
            Section {
                
                List(topTenDetailsViewModel.coinsResponsePrices.prices.reversed(), id: \.self) { coinTimestampAndPrice in
                    if let timestamp = coinTimestampAndPrice.first, let price = coinTimestampAndPrice.last {
                        HStack {
                            Text((price == lastPrice) ? "\(timestamp.timeIntervalToShortDateAndTime)" : "\(timestamp.timeIntervalToShortDateNoTime)")
                                .fontWeight(.light)
                                .foregroundStyle(.primary)
                                .padding(EdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 2))
                            
                            Spacer()
                            Text("\(price.priceString)")
                                .fontWeight(.heavy)
                                .foregroundStyle(.green)
                                .padding(EdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 2))
                        }
                    }
                }
                .listStyle(.automatic)
                .background(.thickMaterial)
                .scrollContentBackground(.hidden)
                .overlay(content: {
                    if (topTenDetailsViewModel.coinsResponsePrices.prices == [[]]), !topTenDetailsViewModel.errorDescription.isEmpty, (topTenDetailsViewModel.errorDescription != CoinGeckoErrors.Error.none.errorDescription || topTenDetailsViewModel.errorDescription != CoinGeckoErrors.Error.missingDetails.errorDescription) {
                        TopTenUnavailableView(title: "Top Ten prices not available", description: Text("Empty price list"))
                    }
                })
                
                Divider()
                
                VStack {
                    Text("Website Link:")
                        .fontWeight(.bold)
                    if homepageLink.isURL() {
                        Link(homepageLink, destination: URL(string: homepageLink)!)
                    } else {
                        Text("No website link")
                            .fontWeight(.light)
                            .foregroundStyle(.red)
                    }

                    Spacer()
                    
                    Text("Description:")
                        .fontWeight(.bold)
                    
                    if !coinDescription.isEmpty {
                        TopTenWebView(text: $coinDescription)
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
                            .font(.title.weight(.ultraLight)) // NB: ignorato
                            .shadow(radius: 5, x: 0, y: 5)
                            .clipped()
                    } else {
                        ProgressView()
                            .opacity(1-coinsDescriptionUnavailableOpacity)
                        TopTenUnavailableView(title: "Top Ten description not available", description: Text("Empty description"))
                            .opacity(coinsDescriptionUnavailableOpacity)
                    }
                    
                    Spacer()
                }
                
            } header: {
                HStack {
                    Spacer()
                    Text("Day")
                        .fontWeight(.bold)
                        .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                    Spacer()
                    Text("Price")
                        .fontWeight(.bold)
                        .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                    Spacer()
                }
                .background(.regularMaterial)
            } footer: {
                HStack {
                    topTenDetailsViewModel.dataManager.networkManager.isConnected ? Image(systemName: "wifi") : Image(systemName: "wifi.exclamationmark")
                    Text(topTenDetailsViewModel.errorDescription)
                        .fontWeight(.light)
                        .foregroundStyle((topTenDetailsViewModel.errorDescription == CoinGeckoErrors.Error.none.errorDescription) ? .blue : .red)
                }
            }
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        }
        .background(.regularMaterial)
        .task {
            await loadDetailsAsync()
        }
        .refreshable {
            await loadDetailsAsync()
        }
    }

    private func loadDetailsAsync() async {
        await topTenDetailsViewModel.loadCoinGeckoMarketChartPrices(coinID: coinID)

        topTenDetailsViewModel.dataManager.networkManager.isConnected ?
        print(">> TopTenDetailsView task loadDetailsAsync: 􀙇 loadCoinGeckoMarketDataDescriptionAndLink(coinID: bitcoin) -> coinsResponseDescription '\(topTenDetailsViewModel.coinsResponseDescription)', + loadCoinGeckoMarketChartPrices(coinID: bitcoin) -> coinsResponsePrices  \(topTenDetailsViewModel.coinsResponsePrices), errorDescription '\(topTenDetailsViewModel.errorDescription)' <<") : print(">> TopTenDetailsView task: 􀙥 No connection , errorDescription \(topTenDetailsViewModel.errorDescription) <<")
        
        await topTenDetailsViewModel.loadCoinGeckoMarketDataDescriptionAndLink(coinID: coinID)

        do {
            coinDescription = try await topTenDetailsViewModel.getDescription() ?? ""
            if coinDescription.isEmpty {
                coinsDescriptionUnavailableOpacity = 1
                topTenDetailsViewModel.errorDescription = CoinGeckoErrors.Error.missingDetails.errorDescription
            }
        }
        catch let error {
            switch error {
            // no case
            default:
                print()
                if coinDescription.isEmpty {
                    coinsDescriptionUnavailableOpacity = 1
                    topTenDetailsViewModel.errorDescription = error.localizedDescription
                }
            }
        }
        
        print(">> TopTenDetailsView task loadDetailsAsync: getDescription coinDescription '\(coinDescription)' topTenDetailsViewModel.coinsResponseDescription.description.en '\(topTenDetailsViewModel.coinsResponseDescription.description.en)'")
        
        

    }

}

#Preview {
    TopTenDetailsView(coinID: "bitcoin")
}
