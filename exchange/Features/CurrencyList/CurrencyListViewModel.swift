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
    
    private let currencies: [Currency]
    private let onSelect: (Currency) -> Void
    private var selectedIndex: Int?
    
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
    
    func selectCurrency(at index: Int) -> (indexPaths: [IndexPath], shouldDismiss: Bool) {
        
        guard index != selectedIndex else { return ([], false) }
        
        let oldIndex = selectedIndex
        selectedIndex = index
        
        var paths = [IndexPath(row: index, section: 0)]
        
        if let oldRow = oldIndex {
            paths.append(IndexPath(row: oldRow, section: 0))
        }
        
        // Handle Selection
        onSelect(currencies[index])
        
        return (paths, true)
    }
}
