//
//  CoinGeckoErrors.swift
//  TopTenMarketCap
//
//  Created by Swift on 29/11/24.
//

import Foundation

struct CoinGeckoErrors {
    
    public enum Error: Swift.Error {
        case invalidFormat
        case internetUnavailable
        case malformedURL
        case missingDetails
        case missingData
        case generic
        case unknown
        case none
        case other
        
        public var errorDescription: String {
            switch self {
            case .invalidFormat:
                return Locale.current.identifier == "it_IT" ? "Impossibile leggere i dati perché non sono nel formato corretto." : Locale.current.identifier == "en_IT" ? "The data couldn’t be read because it isn’t in the correct format." : "Invalid Format"
            case .internetUnavailable:
                return Locale.current.identifier == "it_IT" ? "La connessione a internet sembra essere disattivata." : Locale.current.identifier == "en_IT" ? "The Internet connection appears to be offline." : "Internet Unavailable"
            case .malformedURL:
                return "The resource could not be loaded because the App Transport Security policy requires the use of a secure connection."
            case .missingData:
                return "The data couldn’t be read because it is missing."
            case .missingDetails:
                return "Details Not Available"
            case .generic:
                return "Generic Error"
            case .unknown:
                return "Unknown Error"
            case .none:
                return "No Error"
            default:
                return "Other Error"
            }
        }
    }
}
