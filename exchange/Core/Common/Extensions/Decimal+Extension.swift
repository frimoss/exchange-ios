//
//  Decimal+Extension.swift
//  exchange
//
//  Created by Nikolai on 25/02/2026.
//

import Foundation

extension Decimal {
    
    func toCurrency() -> String {
        self.formatted(.number.precision(.fractionLength(0...2)).grouping(.automatic))
    }
}
