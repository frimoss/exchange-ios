//
//  ExchangeRate.swift
//  exchange
//
//  Created by Nikolai on 16/02/2026.
//

import Foundation

struct ExchangeRate: Decodable {
    
    // MARK: - API Properties
    
    private let ask: String   // Buying price
    private let bid: String   // Selling price
    private let book: String  // Currency pair: "usdc_mxn"
    private let date: String
    
    // MARK: - Domain Properties
    
    var exchangeRate: Decimal {
        return Decimal(string: ask) ?? 0.0
    }

    var currencyCode: String {
        // Book "usdc_mxn" -> "MXN"
        book.components(separatedBy: "_").last?.uppercased() ?? ""
    }
}

// MARK: - Mock Tickers Data -

extension ExchangeRate {
    static var mockRates: [ExchangeRate] = [
        ExchangeRate(ask: "1466.4900", bid: "1462.8138", book: "usdc_ars", date: ""),
        ExchangeRate(ask: "3720.9410", bid: "3680.6000", book: "usdc_cop", date: ""),
        ExchangeRate(ask: "17.1703", bid: "17.1671", book: "usdc_mxn", date: ""),
        ExchangeRate(ask: "5.2589", bid: "5.2065", book: "usdc_brl", date: "")
    ]
}
