//
//  NetworkClient.swift
//  exchange
//
//  Created by Nikolai on 18/02/2026.
//

import Foundation

final class NetworkClient {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - Request Method
    
    func request<T: Decodable>(_ urlString: String) async throws -> T {
        
        // Check URL
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        // Make Request
        let (data, response) = try await session.data(from: url)
        
        // Check Response
        if let httpResponse = response as? HTTPURLResponse {
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            }
        }
        
        // Check Data
        guard !data.isEmpty else {
            throw NetworkError.noData
        }
        
        // Try Decode Data
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}
