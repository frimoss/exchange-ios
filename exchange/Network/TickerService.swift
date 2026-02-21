//
//  TickerService.swift
//  exchange
//
//  Created by Nikolai on 18/02/2026.
//

import Foundation

final class TickerService {
    
    private let client: NetworkClientProtocol
    
    private var cache: [String: [ExchangeRate]] = [:]
    
    // MARK: - Init
    
    init(client: NetworkClientProtocol = NetworkClient()) {
        self.client = client
    }
    
    // MARK: - Private Get Tickers
    
    private func fetchTickers(currencies: [String]) async throws -> [ExchangeRate] {
        
        // Same cache Key for same Currencies ["ARS", "COP"] == ["COP", "ARS"]
        let sorted = currencies.sorted()
        
        let cacheKey = sorted.joined(separator: ",") // Key String: "ARS,COP,MXN,BRL"
        
        // Return Tickers from Cache if exist
        if let cached = cache[cacheKey] {
            print("Get Tickers from Cache")
            
            return cached
        }
        
        // Fetch Tickers
        let rates: [ExchangeRate] = try await client.request(TickerEndpoint.tickers(sorted))
        
        // Save in Cache
        cache[cacheKey] = rates
        print("Rates were Saved in Cache")
        
        return rates
    }
    
    // MARK: - Public Get Currencies
    
    func fetchAvailableCurrencies() async throws -> [Currency] {
        // TODO: Fix return try await client.request(TickerEndpoint.currencies)
        
        print("Using Mock Currencies")
        return Currency.mockCurrencies
    }
    
    // MARK: - Public Fallback Methods -
    
    func fetchTickersWithFallback(currencies: [String]) async -> [ExchangeRate] {
        do {
            return try await fetchTickers(currencies: currencies)
        } catch {
            print("Network Error: \(error.localizedDescription)")
            print("Using Mock Rates")
            return ExchangeRate.mockRates
        }
    }
}
