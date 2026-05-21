//
//  ExchangeAssembly.swift
//  exchange
//
//  Created by Nikolai on 02/03/2026.
//

import UIKit

/// Assembly responsible for injecting dependencies and constructing the Exchange screen.
@MainActor
enum ExchangeAssembly {
    
    /// Builds the `ExchangeViewController` with its full dependency tree.
    static func build() -> UIViewController {
        
        // 1. Service Layer
        let client = NetworkClient()
        let service = TickerService(client: client)
        
        // 2. Domain Layer (Formatting & Logic)
        let formatter = AmountFormatter() /// User Locale (.current) by default
        
        // 3. Presentation Layer
        let viewModel = ExchangeViewModel(
            service: service,
            formatter: formatter
        )
        
        let viewController = ExchangeViewController(viewModel: viewModel)
        
        return viewController
    }
}
