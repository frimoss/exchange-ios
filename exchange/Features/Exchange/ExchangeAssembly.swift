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
        
        let client = NetworkClient()
        
        let service = TickerService(client: client)

        let formatter = AmountFormatter() // Uses Locale.current by default
        
        let viewModel = ExchangeViewModel(service: service, formatter: formatter)
        
        let viewController = ExchangeViewController(viewModel: viewModel)
        
        return viewController
    }
}
