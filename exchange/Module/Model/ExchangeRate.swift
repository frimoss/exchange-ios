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
    
    var currentPrice: Decimal {
        return Decimal(string: ask) ?? 0.0
    }

    var currencyCode: String {
        let parts = book.split(separator: "_") // Book: "usdc_mxn"
        
        guard parts.count == 2 else { return book }
        
        return String(parts[1]).uppercased() // "MXN"
    }
}

//    API GET: Currencies
//    [
//      {
//        "ask": "18.4105000000",
//        "bid": "18.4069700000",
//        "book": "usdc_mxn",
//        "date": "2025-10-20T20:14:57.361483956"
//      }
//    ]
