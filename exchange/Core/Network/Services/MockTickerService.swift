//
//  MockTickerService.swift
//  exchange
//
//  Created by Nikolai on 22/03/2026.
//

import Foundation

final class MockTickerService: TickerServiceProtocol {
    
    // MARK: - Mock Properties
    
    var shouldThrowError = false
    var mockCurrencies: [Currency] = []
    var mockRates: [ExchangeRate] = []
    
    // MARK: - Mock Methods

    func fetchAvailableCurrencies() async throws -> [Currency] {
        
        if shouldThrowError { throw NSError(domain: "Network", code: -1) }
        
        return mockCurrencies
    }

    func fetchTickersWithFallback(currencies: [String]) async -> [ExchangeRate] {
        return mockRates
    }
}
