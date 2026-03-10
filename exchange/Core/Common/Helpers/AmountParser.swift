//
//  AmountParser.swift
//  exchange
//
//  Created by Nikolai on 07/03/2026.
//

import Foundation

enum AmountParser {
    
    // NumberFormatter - Static to optimize using RAM (only 1 object during lifetime of the App)
    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = .current
        formatter.usesGroupingSeparator = true
        
        return formatter
    }()
    
    // Decimal Value from Text Amount
    static func parse(_ text: String?) -> Decimal? {
        guard let text = text, !text.isEmpty else { return nil }
        
        return formatter.number(from: text)?.decimalValue
    }
    
    // Raw Value from Formatted Text
    static func getRawValue(from text: String?) -> String {
        guard let text, let decimal = parse(text) else { return text ?? "" }
        
        let separator = Locale.current.decimalSeparator ?? "."
        
        var result = (decimal as NSDecimalNumber).stringValue // Always "." as Separator
        
        if separator != "." {
            result = result.replacingOccurrences(of: ".", with: separator)
        }
        
        return result
    }
}
