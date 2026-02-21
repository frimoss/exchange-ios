//
//  MockNetworkClient.swift
//  exchange
//
//  Created by Nikolai on 20/02/2026.
//

import Foundation

final class MockNetworkClient: NetworkClientProtocol {
    
    // MARK: - Mock Request Method
    
    func request<T: Decodable>(_ endpoint: TickerEndpoint) async throws -> T {
        
        let filename = mockFilename(for: endpoint)
        
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else { throw NetworkError.invalidURL
        }
        
        let data = try Data(contentsOf: url)
        
        print("Using Mock NetworkClient for path: \(endpoint.path) (\(filename).json)")
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    // MARK: - Filenames of Mock JSON Files
    
    private func mockFilename(for endpoint: TickerEndpoint) -> String {
        
        switch endpoint {
        case .currencies:   return "currencies"
        case .tickers:      return "exchange_rate"
        }
    }
}
