//
//  NetworkClient.swift
//  exchange
//
//  Created by Nikolai on 18/02/2026.
//

import Foundation

final class NetworkClient: NetworkClientProtocol {
    
    private let baseURL: String
    private let session: URLSession
    
    init(baseURL: String = AppConfig.API.baseURL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }
    
    // MARK: - Request Method
    
    func request<T: Decodable>(_ endpoint: TickerEndpoint) async throws -> T {
        
        // Create URL with Query Items
        var components = URLComponents(string: baseURL + endpoint.path)
        components?.queryItems = endpoint.queryItems
        
        // Check URL
        guard let url = components?.url else {
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
