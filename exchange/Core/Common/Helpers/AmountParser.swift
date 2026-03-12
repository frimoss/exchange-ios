//
//  AmountParser.swift
//  exchange
//
//  Created by Nikolai on 07/03/2026.
//

import Foundation

enum AmountParser {
    
    // MARK: - Private NumberFormatter
    
    // Formatter for Parsing Amount
    private static let displayFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = .current
        formatter.usesGroupingSeparator = true // with Separator
        
        return formatter
    }()
    
    // Formatter for Raw Value of Amount
    private static let rawFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = .current
        formatter.usesGroupingSeparator = false // No Separator
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.roundingMode = .halfUp // Math Rounding
        
        return formatter
    }()
    
    // MARK: - Public Functions
    
    // Decimal Value from Text Amount
    static func parse(_ text: String?) -> Decimal? {
        guard let text = text, !text.isEmpty else { return nil }
        
        return displayFormatter.number(from: text)?.decimalValue
    }
    
    // Raw Value from Formatted Amount
    static func getRawValue(from text: String?) -> String {
        guard let decimal = parse(text) else { return text ?? "" }
        
        return rawFormatter.string(from: decimal as NSDecimalNumber) ?? ""
    }
}
