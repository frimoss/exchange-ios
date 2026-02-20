//
//  Currency.swift
//  exchange
//
//  Created by Nikolai on 16/02/2026.
//

import Foundation

struct Currency: Decodable {
    
    let code: String
    
    var id: String { code }
    
    var imageName: String {
        return code.uppercased()
    }
}

// MARK: - Mock Currencies Data -

extension Currency {
    // Fixed USD to MXN (by default)
    static let usd = Currency(code: "USD")
    static let mxn = Currency(code: "MXN")
    
    static var mockCurrencies: [Currency] = [
        Currency(code: "ARS"),
        Currency(code: "COP"),
        Currency(code: "MXN"),
        Currency(code: "BRL")
    ]
}
