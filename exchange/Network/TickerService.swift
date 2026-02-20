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
        
        let joined = currencies.joined(separator: ",") // API Param String: "ARS,COP,MXN,BRL"
        
        // Return Tickers from Cache if exist
        if let cached = cache[joined] {
            print("Get Tickers from Cache")
            
            return cached
        }
        
        let urlString = "\(baseURL)/tickers?currencies=\(joined)"
        
        // Fetch Tickers
        let rates: [ExchangeRate] = try await client.request(urlString)
        
        // Save in Cache
        cache[joined] = rates
        print("Rates were Saved in Cache")
        
        return rates
    }
    
    // MARK: - Public Get Currencies
    
    func fetchAvailableCurrencies() async -> [Currency] {
        // TODO: Fix return try await client.request("\(baseURL)/tickers-currencies")
        
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
