//
//  ExchangeError.swift
//  exchange
//
//  Created by Nikolai on 03/04/2026.
//

import Foundation

enum ExchangeError: LocalizedError {
    
    case emptyResponse      // Server Empty Response
    case offline            // No Internet connection (on the User's side)
    case serverError        // Server Error: 500, Timeout, etc
    case unknown(Error)     // Any other Error (for logs)

    /// The User will see this error message
    var errorDescription: String? {
        switch self {
        case .emptyResponse: return "No exchange rates available at the moment. Using outdated rates."
        case .offline: return "You appear to be offline. Please check your Internet connection. Using outdated rates."
        case .serverError: return "Our service is temporarily unavailable. Using outdated rates."
        case .unknown: return "Something went wrong. Using outdated rates."
        }
    }
    
    // MARK: - Static Mapping Logic
    
    static func map(_ error: Error) -> ExchangeError {
        // 1. Exchange Error
        if let exchangeError = error as? ExchangeError {
            return exchangeError
        }
        
        // 2. Network Layer Error
        if let netError = error as? NetworkError {
            return mapNetworkError(netError)
        }
        
        // 3. URLSession Error
        if let urlError = error as? URLError {
            return mapURLError(urlError)
        }
        
        return .unknown(error)
    }
    
    // MARK: - Private Methods
    
    private static func mapNetworkError(_ error: NetworkError) -> ExchangeError {
        switch error {
        case .noData, .decodingFailed: return .emptyResponse
        case .serverError: return .serverError
        default: return .unknown(error)
        }
    }

    private static func mapURLError(_ error: URLError) -> ExchangeError {
        switch error.code {
        case .notConnectedToInternet, .networkConnectionLost: return .offline
        case .timedOut, .cannotConnectToHost: return .serverError
        default: return .unknown(error)
        }
    }
}
