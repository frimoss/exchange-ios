//
//  CurrencyListAssembly.swift
//  exchange
//
//  Created by Nikolai on 03/03/2026.
//

import UIKit

/// Assembly responsible for constructing the Currency Selection screen.
@MainActor
enum CurrencyListAssembly {
    
    /// Builds the `CurrencyListViewController` using provided selection data.
    static func build(
        currencies: [Currency],
        selectedCurrency: Currency,
        onSelect: @escaping (Currency) -> Void
    ) -> UIViewController {
        
        // 1. Presentation Layer
        let viewModel = CurrencyListViewModel(
            currencies: currencies,
            selectedCurrency: selectedCurrency,
            onSelect: onSelect
        )
        
        let viewController = CurrencyListViewController(viewModel: viewModel)
        
        return viewController
    }
}
