//
//  MockTickerService.swift
//  exchange
//
//  Created by Nikolai on 22/03/2026.
//

import Foundation
@testable import exchange

final class MockTickerService: TickerServiceProtocol {
    
    // MARK: - Stub Properties
    
    var stubbedError: Error?

    var mockCurrencies: [Currency] = []
    var mockRates: [ExchangeRate] = []
    
    // MARK: - Mock Methods
    
    func fetchTickers(currencies: [String]) async throws -> [ExchangeRate] {
        // If we set a specific error - throw it
        if let error = stubbedError { throw error }
        
        return mockRates
    }
    
    func fetchAvailableCurrencies() async throws -> [Currency] {
        return mockCurrencies
    }
}
