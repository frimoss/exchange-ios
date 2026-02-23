//
//  NetworkClient.swift
//  exchange
//
//  Created by Nikolai on 18/02/2026.
//

import Foundation

protocol NetworkClientProtocol {
    func request<T: Decodable, E: Endpoint>(_ endpoint: E) async throws -> T
}

final class NetworkClient: NetworkClientProtocol {
    
    private let baseURL: String
    private let session: URLSession
    private let decoder: JSONDecoder
    
    // MARK: - Init
    
    init(
        baseURL: String = AppConfig.API.baseURL,
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.baseURL = baseURL
        self.session = session
        self.decoder = decoder
    }
    
    // MARK: - Request Method
    
    func request<T: Decodable, E: Endpoint>(_ endpoint: E) async throws -> T {
        
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
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}
