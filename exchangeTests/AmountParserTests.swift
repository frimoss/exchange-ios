//
//  AmountParserTests.swift
//  exchangeTests
//
//  Created by Nikolai on 19/03/2026.
//

import XCTest
@testable import exchange

final class AmountParserTests: XCTestCase {
    
    private let separator = Locale.current.decimalSeparator ?? "."
    
    
    // MARK: - Validation Logic Tests (isValid) -

    func test_isValid_withValidAmount_returnsTrue() {
        
        let input = "123\(separator)45"
        
        XCTAssertTrue(AmountParser.isValid(input))
    }

    func test_isValid_exceedingMaxDigitsBeforeSeparator_returnsFalse() {
        
        // The limit is 7 digits. We insert 8 digits.
        let input = "12345678"
        
        XCTAssertFalse(AmountParser.isValid(input))
    }

    func test_isValid_exceedingMaxDigitsAfterSeparator_returnsFalse() {
        
        // The limit is 2 digits after dot. We insert 3 digits.
        let input = "50\(separator)123"
        
        XCTAssertFalse(AmountParser.isValid(input))
    }

    func test_isValid_withMultipleSeparators_returnsFalse() {
        
        // Entering two Separators
        let input = "10\(separator)50\(separator)5"
        
        XCTAssertFalse(AmountParser.isValid(input))
    }

    
    // MARK: - Parsing Tests (parse) -

    func test_parse_nonNumericString_returnsNil() {
        
        // Letters instead of numbers
        let input = "100abc"
        
        XCTAssertNil(AmountParser.parse(input))
    }

    func test_parse_emptyString_returnsNil() {
        XCTAssertNil(AmountParser.parse(""))
        XCTAssertNil(AmountParser.parse(nil))
    }

    func test_parse_boundaryMaxValues_returnsCorrectDecimal() {
        
        // Maximum allowed number: 9 999 999.99
        let input = "9999999\(separator)99"
        
        // Decimal Result
        let result = AmountParser.parse(input)
        
        // Decimal Expected: Using Fixed Locale - en_US (as anchor for Tests)
        let expected = Decimal(string: "9999999.99", locale: Locale(identifier: "en_US"))
        
        // Compare Decimal Objects
        XCTAssertEqual(result, expected)
    }

    
    // MARK: - Raw Value Tests (getRawValue) -
    
    func test_getRawValue_removesGroupingSeparators() {
        
        let systemGroupingSeparator = Locale.current.groupingSeparator ?? " "
        
        // Formatted value: "1 000.50"
        let input = "1\(systemGroupingSeparator)000\(separator)50"
        
        // Raw Value -> "1000.50"
        let result = AmountParser.getRawValue(from: input)
        
        XCTAssertFalse(result.contains(" "))
        XCTAssertFalse(result.contains(systemGroupingSeparator))
    }

    func test_getRawValue_roundsUsingHalfUp() {
        
        // RawFormatter with .halfUp и 2 digits after dot
        let input = "10\(separator)555"
        
        // Should return: "10.555" -> "10.56"
        let result = AmountParser.getRawValue(from: input)
   
        XCTAssertEqual(result, "10\(separator)56")
    }

    func test_getRawValue_withLeadingZeros_returnsCleanNumber() {
        
        // Extra Zeros in front
        let input = "00\(separator)5" // "00.5"
        
        // Should return "00.5" -> "0.5"
        let result = AmountParser.getRawValue(from: input)
        
        XCTAssertEqual(result, "0\(separator)5")
    }
}
