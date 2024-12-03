//
//  TopTenListView.swift
//  TopTenMarketCap
//
//  Created by Swift on 01/12/24.
//

import SwiftUI

struct TopTenListView: View {
    
    @StateObject private var navigationCoordinator = NavigationCoordinator()
    @ObservedObject var topTenListViewModel = TopTenListViewModel()
    
    var pingResponseString: String { topTenListViewModel.pingResponseString }
    var coinsResponseList: [CoinsMarketsModel] { topTenListViewModel.coinsResponseList }
    var errorDescription: String { topTenListViewModel.errorDescription }
    
    @State var text = ""
        
    var body: some View {

        NavigationStack(path: $navigationCoordinator.navigationPath) {

            List (topTenListViewModel.coinsResponseList, id: \.self) { coinsMarket in
                HStack {
                    
                    AsyncImage(url: URL(string: coinsMarket.image)) { result in
                        switch result {
                        case .failure:
                            Image(systemName: "questionmark.circle.dashed")
                                .font(.largeTitle)
                                .foregroundStyle(.red)
                        case .success(let image):
                            image.resizable()
                        default:
                            ProgressView()
                        }
                    }
                    .frame(width: 40, height: 40)
                    .clipShape(.rect(cornerRadius: 2))
                    Text(coinsMarket.name)
                        .foregroundStyle(.tint)
                    Spacer()
                    NavigationLink("\(coinsMarket.current_price)", value: coinsMarket.id)
                        .foregroundStyle(.green)
                }
            }
            .listStyle(.automatic)
            .foregroundStyle(.tint)
            .navigationTitle("Top 10 Coins")
            .refreshable {
                await topTenListViewModel.pingCoinGeckoServer()
                await topTenListViewModel.loadCoinGeckoMarkets()
            }
            .overlay(content: {
                if topTenListViewModel.coinsResponseList.isEmpty {
                    TopTenUnavailableView(title: "Top Ten coins not available", description: Text("Empty list"))
                }
            })
            .navigationDestination(for: String.self) { coinID in
                TopTenDetailsView(coinID: coinID)
            }
            if topTenListViewModel.errorDescription.isEmpty || topTenListViewModel.errorDescription == CoinGeckoErrors.Error.none.errorDescription {
                Text("CoinGecko Says: \(topTenListViewModel.dataManager.pingResponse?.gecko_says ?? "")")
                    .fontWeight(.ultraLight)
            } else {
                Text("Error: \(topTenListViewModel.errorDescription)")
                    .fontWeight(.light)
                    .foregroundStyle(.red)
            }

        } // NavigationStack
        .environmentObject(navigationCoordinator)
        .task {
            await topTenListViewModel.pingCoinGeckoServer()

            await topTenListViewModel.loadCoinGeckoMarkets()
            
            topTenListViewModel.dataManager.networkManager.isConnected ?
            print(">> TopTenDetailsView task: pingCoinGeckoServer -> pingResponseString '\(topTenListViewModel.pingResponseString)' , gecko_says '\(topTenListViewModel.dataManager.pingResponse?.gecko_says ?? "")', +  loadCoinGeckoMarkets -> coinsResponseList count \(topTenListViewModel.coinsResponseList.count) , errorDescription '\(topTenListViewModel.errorDescription)' <<") : print(">> TopTenDetailsView task: No connection , errorDescription \(topTenListViewModel.errorDescription) <<")
        }
    }
}

#Preview {
    TopTenListView()
}
