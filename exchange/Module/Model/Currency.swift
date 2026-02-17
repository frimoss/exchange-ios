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
    static var mockCurrencies: [Currency] {
        [
            Currency(code: "ARS"),
            Currency(code: "COP"),
            Currency(code: "MXN"),
            Currency(code: "BRL")
        ]
    }
}

//    API GET: Tickers
//    [
//      "MXN",
//      "ARS",
//      "BRL",
//      "COP"
//    ]
