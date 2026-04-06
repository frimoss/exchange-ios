//
//  AmountParser.swift
//  exchange
//
//  Created by Nikolai on 07/03/2026.
//

import Foundation

enum AmountParser {
    
    // MARK: - Amount Limits
    
    private typealias Config = AppConfig.Amount
    
    // MARK: - Formatters
    
    // Formatter for Parsing Amount
    private static let displayFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = .current
        formatter.generatesDecimalNumbers = true // Use Decimal instead of Double
        formatter.usesGroupingSeparator = true // with Separator
        
        return formatter
    }()
    
    // Formatter for Raw Value of Amount
    private static let rawFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = .current
        formatter.usesGroupingSeparator = false // No Separator
        formatter.roundingMode = .halfUp // Math Rounding Up
        
        return formatter
    }()
    
    // MARK: - Validation Logic
    
    static func isValid(_ text: String) -> Bool {
        // Check Separator
        let separator = Locale.current.decimalSeparator ?? "."
        let components = text.components(separatedBy: separator)
        
        // Two parts: Before and After separator
        guard components.count <= 2 else { return false }
        
        let beforeSeparator = components[0]
        let afterSeparator = components.count > 1 ? components[1] : ""
        
        // No Minus sign
        let positiveBeforeSeparator = beforeSeparator.replacingOccurrences(of: "-", with: "")
        
        // Max Digits Validation
        if positiveBeforeSeparator.count > Config.maxDigitsBeforeSeparator { return false }
        if afterSeparator.count > Config.highPrecisionMaxFractionDigits { return false }
        
        return true
    }
    
    // MARK: - Formatting Logic
    
    /// Decimal Value from Text Amount
    static func parse(_ text: String?) -> Decimal? {
        guard let text = text, !text.isEmpty else { return nil }
        
        return displayFormatter.number(from: text)?.decimalValue
    }
    
    /// Raw Value from Formatted Amount
    static func getRawValue(from text: String?) -> String {
        guard let decimal = parse(text) else { return text ?? "" }
  
        // Adaptive Fraction Digits
        rawFormatter.maximumFractionDigits = Config.precision(for: decimal)

        return rawFormatter.string(from: decimal as NSDecimalNumber) ?? ""
    }
}
