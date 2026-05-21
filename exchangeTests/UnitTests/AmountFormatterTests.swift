//
//  AmountFormatterTests.swift
//  exchangeTests
//
//  Created by Nikolai on 11/04/2026.
//

import XCTest
@testable import exchange

final class AmountFormatterTests: XCTestCase {
    
    func test_enUS_Formatting() {
        let sut = AmountFormatter(locale: Locale(identifier: "en_US"))
        let value: Decimal = 1234.56
        
        XCTAssertEqual(sut.format(value), "1,234.56")
    }
    
    func test_esAR_Formatting() {
        // Testing Argentina locale (uses dot for thousands, comma for decimals)
        let sut = AmountFormatter(locale: Locale(identifier: "es_AR"))
        let value: Decimal = 1234.56
        
        XCTAssertEqual(sut.format(value), "1.234,56")
    }
    
    func test_zeroValue_returnsZeroString() {
        let sut = AmountFormatter(locale: Locale(identifier: "en_US"))
        XCTAssertEqual(sut.format(0), "0")
    }
    
    func test_nilValue_returnsEmptyString() {
        let sut = AmountFormatter()
        XCTAssertEqual(sut.format(nil), "")
    }
}
