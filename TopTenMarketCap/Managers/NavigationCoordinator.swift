//
//  NavigationCoordinator.swift
//  TopTenMarketCap
//
//  Created by Swift on 01/12/24.
//

import Foundation
import SwiftUI

enum TopTenPage: Hashable {
    case list
    case detail(coinID: String)
}

@available(macOS 13.0, *)
final class NavigationCoordinator: ObservableObject {

    @Published var navigationPath: NavigationPath
    
    /// No elements in navigationPath
    var isRootPage: Bool {
        navigationPath.isEmpty
    }

    /// Number of elements in navigationPath
    var numPages: Int {
        navigationPath.count
    }
    
    init() {
        self.navigationPath = NavigationPath()
    }
    
    /// Append an element from deeplink to navigationPath
    func push(topTenPage: TopTenPage) {
        switch (topTenPage) {
        case .list:
            print(">> NavigationCoordinator push TopTenPage root .list")
            navigationPath.removeLast(navigationPath.count)
        case let .detail(coinID):
            print(">> NavigationCoordinator push TopTenPage .detail: coinID \(coinID)")
            navigationPath.append(coinID)
        }
    }
    
    /// Append to navigationPath a provided CoinID detail page
    func navigate(to coinID: String) {
            self.navigationPath.append(coinID)
    }
    
    /// Remove last element from navigationPath
    func pop() {
        navigationPath.removeLast()
    }
    
    /// Remove all elements from navigationPath
    func backToRoot() {
        print(">> NavigationCoordinator backToRoot: navigationPath.count \(self.navigationPath.count) <<")
        navigationPath.removeLast(navigationPath.count)
    }
}
