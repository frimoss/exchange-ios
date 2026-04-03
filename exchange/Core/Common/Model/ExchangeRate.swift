//
//  ExchangeRate.swift
//  exchange
//
//  Created by Nikolai on 16/02/2026.
//

import Foundation

struct ExchangeRate: Decodable {
    
    // MARK: - API Properties
    
    let ask: String   // Buying price
    let bid: String   // Selling price
    let book: String  // Currency pair: "usdc_mxn"
    let date: String
    
    // MARK: - Domain Properties
    
    var exchangeRate: Decimal {
        let askDecimal = Decimal(string: ask) ?? 0
        let bidDecimal = Decimal(string: bid) ?? 0
        
        return (askDecimal + bidDecimal) / 2
    }

    var currencyCode: String {
        // Book "usdc_mxn" -> "MXN"
        book.components(separatedBy: "_").last?.uppercased() ?? ""
    }
}

// MARK: - Mock Tickers Data -

extension ExchangeRate {
    static var mockDictRates: [String: Decimal] = ["ARS": 1466.49, "COP": 3720.94, "MXN": 17.17, "BRL": 5.26]
}
