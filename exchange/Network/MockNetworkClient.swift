//
//  MockDataProvider.swift
//  exchange
//
//  Created by Nikolai on 20/02/2026.
//

import Foundation

final class MockNetworkClient: NetworkClientProtocol {
    
    private let filename: String
    
    init(filename: String) {
        self.filename = filename
    }
    
    // MARK: - Mock Request Method
    
    func request<T: Decodable>(_ urlString: String) async throws -> T {
        
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            throw NetworkError.invalidURL
        }
        
        let data = try Data(contentsOf: url)
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
