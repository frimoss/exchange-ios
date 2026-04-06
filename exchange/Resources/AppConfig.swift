//
//  AppConfig.swift
//  exchange
//
//  Created by Nikolai on 20/02/2026.
//

import Foundation

enum AppConfig {
    
    enum API {
        static let baseURL = "https://api.dolarapp.dev/v1"
    }
    
    /// Amount Limits
    enum Amount {
        static let maxDigitsBeforeSeparator = 7         // 1_000_000
        static let defaultMaxFractionDigits = 2         // 0.12
        static let highPrecisionMaxFractionDigits = 6   // 0.000992
        
        /// Maximum Fraction Digits
        static func precision(for value: Decimal) -> Int {
            return (value > 0 && value < 1.0) ? highPrecisionMaxFractionDigits : defaultMaxFractionDigits
        }
    }
}
