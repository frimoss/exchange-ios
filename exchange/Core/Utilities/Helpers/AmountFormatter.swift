//
//  AmountFormatter.swift
//  exchange
//
//  Created by Nikolai on 05/04/2026.
//

import Foundation

struct AmountFormatter {
    
    // MARK: - Dependencies
    
    private let locale: Locale
    
    // MARK: - Init
    
    init(locale: Locale = .current) {
        self.locale = locale
    }
    
    // MARK: - Public Methods
    
    func format(_ value: Decimal?) -> String {
        guard let value = value else { return "" }
        
        let maxPrecision = AppConfig.Amount.precision(for: value)
        
        return value.formatted(
            .number
            .precision(.fractionLength(0...maxPrecision))
            .grouping(.automatic)
            .locale(locale)
        )
    }
}
