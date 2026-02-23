//
//  EndpointProtocol.swift
//  exchange
//
//  Created by Nikolai on 23/02/2026.
//

import Foundation

protocol Endpoint {
    var path: String { get }
    var queryItems: [URLQueryItem]?  { get }
}
