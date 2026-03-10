//
//  AmountParser.swift
//  exchange
//
//  Created by Nikolai on 07/03/2026.
//

import Foundation

enum AmountParser {
    
    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = .current
        formatter.usesGroupingSeparator = true
        
        return formatter
    }()
    
    // Static NumberFormatter parse() - to optimise using RAM
    static func parse(_ text: String?) -> Decimal? {
        guard let text = text, !text.isEmpty else { return nil }
        
        return formatter.number(from: text)?.decimalValue
    }
    
    static func getRawValue(from text: String?) -> String {
        
        guard let text = text, let decimal = parse(text) else { return text ?? "" }
        
        let separator = Locale.current.decimalSeparator ?? "."
        
        return "\(decimal)".replacingOccurrences(of: ".", with: separator)
    }
}
