//
//  MockNetworkClient.swift
//  exchange
//
//  Created by Nikolai on 20/02/2026.
//

import Foundation

final class MockNetworkClient: NetworkClientProtocol {
    
    private let decoder: JSONDecoder
    
    // MARK: - Init
    
    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }
    
    // MARK: - Mock Request Method
    
    func request<T: Decodable, E: Endpoint>(_ endpoint: E) async throws -> T {
        
        // Check Filename.JSON in the Project for MOCK Tests
        guard
            let filename = mockFilename(for: endpoint),
            let url = Bundle.main.url(forResource: filename, withExtension: "json")
        else {
            throw NetworkError.invalidURL
        }
        
        let data = try Data(contentsOf: url)
        
        print("Using Mock NetworkClient for path: \(endpoint.path) (\(filename).json)")
        
        return try decoder.decode(T.self, from: data)
    }
    
    // MARK: - Filenames of Mock JSON Files
    
    private func mockFilename<E: Endpoint>(for endpoint: E) -> String? {
        
        guard let tickerEndpoint = endpoint as? TickerEndpoint else { return nil }
        
        switch tickerEndpoint {
        case .currencies:   return "currencies"
        case .tickers:      return "exchange_rate"
        }
    }
}
