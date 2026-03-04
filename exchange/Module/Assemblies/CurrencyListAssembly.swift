//
//  CurrencyListAssembly.swift
//  exchange
//
//  Created by Nikolai on 03/03/2026.
//

import UIKit

@MainActor
enum CurrencyListAssembly {
    
    static func build(
        currencies: [Currency],
        selectedCurrency: Currency,
        onSelect: @escaping (Currency) -> Void
        
    ) -> UIViewController {
        
        let viewModel = CurrencyListViewModel(
            currencies: currencies,
            selectedCurrency: selectedCurrency,
            onSelect: onSelect
        )
        
        let viewController = CurrencyListViewController(viewModel: viewModel)
        
        return viewController
    }
}
