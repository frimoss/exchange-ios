//
//  NetworkError.swift
//  exchange
//
//  Created by Nikolai on 18/02/2026.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingFailed
    case serverError(statusCode: Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .noData: return "Empty server response"
        case .decodingFailed: return "Failed to decode server response"
        case .serverError(let statusCode): return "Server Error: \(statusCode)"
        }
    }
}
