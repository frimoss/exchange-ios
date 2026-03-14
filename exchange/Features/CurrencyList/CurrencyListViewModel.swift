//
//  CurrencyListViewModel.swift
//  exchange
//
//  Created by Nikolai on 03/03/2026.
//

import UIKit

@MainActor
final class CurrencyListViewModel {
    
    // MARK: - Properties
    
    private(set) var currencies: [Currency]
    
    private(set) var selectedIndex: Int?
    
    private let onSelect: (Currency) -> Void
    
    var shouldDismiss: Bool = false
    
    // MARK: - Init
    
    init(currencies: [Currency], selectedCurrency: Currency, onSelect: @escaping (Currency) -> Void) {
        self.currencies = currencies
        self.onSelect = onSelect
        self.selectedIndex = currencies.firstIndex(where: { $0.code == selectedCurrency.code })
    }
    
    // MARK: - Data Source Logic
    
    var numberOfCurrencies: Int {
        currencies.count
    }
    
    func currency(at index: Int) -> Currency {
        currencies[index]
    }
    
    func isSelected(at index: Int) -> Bool {
        selectedIndex == index
    }
    
    // MARK: - Actions
    
    func selectCurrency(at index: Int) {
        
        // Check already selected
        if index == selectedIndex {
            shouldDismiss = true
            return
        }
        
        // Update Selected Index
        selectedIndex = index
        
        // Handle Selection
        onSelect(currencies[index])
        
        // Close sheet
        shouldDismiss = true
    }
}
