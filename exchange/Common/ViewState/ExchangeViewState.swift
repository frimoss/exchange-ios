//
//  ExchangeViewState.swift
//  exchange
//
//  Created by Nikolai on 16/02/2026.
//

import Foundation

struct ExchangeViewState {
    
    var currencies: [Currency] = []

    var selectedCurrencyCode: String?
    
    var inputAmount: Decimal = 0
    
    var rates: [String: Decimal] = [:]
}
