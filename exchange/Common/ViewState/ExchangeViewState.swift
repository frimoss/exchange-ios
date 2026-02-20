//
//  ExchangeViewState.swift
//  exchange
//
//  Created by Nikolai on 16/02/2026.
//

import Foundation

enum ActiveField {
    case top
    case bottom
}

enum ConversionDirection {
    case usdToSelected // USD to MXN
    case selectedToUsd // MXN to USD
}

struct ExchangeViewState {
    
    // MARK: - Store Data
    
    var currencies: [Currency] = [] // Sheet Available Currencies
    var rates: [String: Decimal] = [:] // All Available Rates ["MXN": 17.17, "ARS": 1466.49]

    // MARK: - Selected Currency
    
    var selectedCurrency: Currency = .mxn // USD to MXN (by default)
    
    // MARK: - Input Fields
    
    var topAmount = "1" // $1 (by default)
    var bottomAmount = ""
    
    var activeField: ActiveField = .top
    
    // MARK: - Conversion Direction
    
    var direction: ConversionDirection = .usdToSelected // Change by SWAP Button
    
    // MARK: - State
    
    var isLoading: Bool = false
    var errorMessage: String?
    
    // MARK: - Computed Properties
    
    var topCurrency: Currency {
        switch direction {
        case .usdToSelected: return Currency.usd
        case .selectedToUsd: return selectedCurrency
        }
    }
    
    var bottomCurrency: Currency {
        switch direction {
        case .usdToSelected: return selectedCurrency
        case .selectedToUsd: return Currency.usd
        }
    }
    
    // Current Rate
    var exchangeRate: Decimal? {
        return rates[selectedCurrency.code]
    }
}
