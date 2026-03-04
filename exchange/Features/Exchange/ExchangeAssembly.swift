//
//  ExchangeAssembly.swift
//  exchange
//
//  Created by Nikolai on 02/03/2026.
//

import UIKit

@MainActor
enum ExchangeAssembly {
    
    static func build() -> UIViewController {
        
        let client = NetworkClient() // MockNetworkClient()
        
        let service = TickerService(client: client)
        
        let viewModel = ExchangeViewModel(service: service)
        
        let viewController = ExchangeViewController(viewModel: viewModel)
        
        return viewController
    }
}
