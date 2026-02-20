//
//  NetworkClientProtocol.swift
//  exchange
//
//  Created by Nikolai on 20/02/2026.
//

import Foundation

protocol NetworkClientProtocol {
    func request<T: Decodable>(_ endpoint: TickerEndpoint) async throws -> T
}
