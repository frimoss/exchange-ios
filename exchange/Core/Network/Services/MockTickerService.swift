//
//  MockTickerService.swift
//  exchange
//
//  Created by Nikolai on 22/03/2026.
//

import Foundation

final class MockTickerService: TickerServiceProtocol {
    
    func fetchAvailableCurrencies() async throws -> [Currency] {
        return [
            Currency(code: "ARS"),
            Currency(code: "COP"),
            Currency(code: "MXN"),
            Currency(code: "BRL")
        ]
    }
    
    func fetchTickersWithFallback(currencies: [String]) async -> [ExchangeRate] {
        return [
            //ExchangeRate(ask: "1466.4900", bid: "1462.8138", book: "usdc_ars", date: ""),
            ExchangeRate(ask: "3720.9410", bid: "3680.6000", book: "usdc_cop", date: ""),
            ExchangeRate(ask: "17.1703", bid: "17.1671", book: "usdc_mxn", date: ""),
            ExchangeRate(ask: "5.2589", bid: "5.2065", book: "usdc_brl", date: "")
        ]
    }
}
