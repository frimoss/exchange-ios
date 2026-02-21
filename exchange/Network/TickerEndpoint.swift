//
//  TickerEndpoint.swift
//  exchange
//
//  Created by Nikolai on 20/02/2026.
//

import Foundation

enum TickerEndpoint {
    
    case currencies
    case tickers([String])
    
    var path: String {
        switch self {
        case .currencies:   return "/tickers-currencies"
        case .tickers:      return "/tickers"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .currencies:
            return nil
            
        case .tickers(let list): // API Param: "/tickers?currencies=\(list)"
            return [URLQueryItem(name: "currencies", value: list.joined(separator: ","))]
        }
    }
}
