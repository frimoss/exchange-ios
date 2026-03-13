//
//  AmountParser.swift
//  exchange
//
//  Created by Nikolai on 07/03/2026.
//

import Foundation

enum AmountParser {
    
    // MARK: - Amount Limits
    
    enum Constants {
        static let maxDigitsBeforeSeparator = 7 // 1_000_000
        static let maxDigitsAfterSeparator = 2  // 0.12
    }
    
    // MARK: - Amount Formatters
    
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
        formatter.maximumFractionDigits = Constants.maxDigitsAfterSeparator
        formatter.roundingMode = .halfUp // Math Rounding Up
        
        return formatter
    }()
    
    // MARK: -  Validation Logic
    
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
        
        //
        if positiveBeforeSeparator.count > Constants.maxDigitsBeforeSeparator { return false }
        if afterSeparator.count > Constants.maxDigitsAfterSeparator { return false }
        
        return true
    }
    
    // MARK: - Decimal Value from Text Amount
    
    static func parse(_ text: String?) -> Decimal? {
        guard let text = text, !text.isEmpty else { return nil }
        
        return displayFormatter.number(from: text)?.decimalValue
    }
    
    // MARK: - Raw Value from Formatted Amount
    
    static func getRawValue(from text: String?) -> String {
        guard let decimal = parse(text) else { return text ?? "" }
        
        return rawFormatter.string(from: decimal as NSDecimalNumber) ?? ""
    }
}
