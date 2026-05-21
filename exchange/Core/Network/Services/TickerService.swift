//
//  TickerService.swift
//  exchange
//
//  Created by Nikolai on 18/02/2026.
//

import Foundation

protocol TickerServiceProtocol {
    func fetchTickers(currencies: [String]) async throws -> [ExchangeRate]
    func fetchAvailableCurrencies() async throws -> [Currency]
}

final class TickerService: TickerServiceProtocol {
    
    // MARK: - Dependencies
    
    private let client: NetworkClientProtocol
    
    // MARK: - Private Properties
    
    private var memoryCache: [String: [ExchangeRate]] = [:]
    
    // MARK: - Init
    
    init(client: NetworkClientProtocol) {
        self.client = client
    }
    
    // MARK: - Get Tickers
    
    func fetchTickers(currencies: [String]) async throws -> [ExchangeRate] {
        // Same cache Key for same Currencies ["ARS", "COP"] == ["COP", "ARS"]
        let sorted = currencies.sorted()
        let cacheKey = sorted.joined(separator: ",") // Key String: "ARS,COP,MXN,BRL"
        
        // Return Tickers from Cache if exist
        if let cached = memoryCache[cacheKey] {
            print("Get Tickers from Cache")
            return cached
        }
        
        // Fetch Tickers
        let rates: [ExchangeRate] = try await client.request(TickerEndpoint.tickers(sorted))
        
        // Save in Cache
        memoryCache[cacheKey] = rates
        print("Rates were Saved in Cache")
        
        return rates
    }
    
    // MARK: - Get Currencies
    
    func fetchAvailableCurrencies() async throws -> [Currency] {
        // TODO: Fix return try await client.request(TickerEndpoint.currencies)
        return Currency.mockCurrencies
    }
}
