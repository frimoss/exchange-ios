//
//  ExchangeViewModelTests.swift
//  exchangeTests
//
//  Created by Nikolai on 19/03/2026.
//

import XCTest
@testable import exchange

@MainActor
final class ExchangeViewModelTests: XCTestCase {
    
    // SUT - System Under Test (from David Piper)
    private var sut: ExchangeViewModel!
    private var mockService: MockTickerService!

    // Test Start
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockService = MockTickerService()
        sut = ExchangeViewModel(service: mockService)
    }

    // Test Finish
    override func tearDownWithError() throws {
        sut = nil
        mockService = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Tests

    func test_loadInitialData_whenRatesMissing_shouldFilterCurrencies() async throws {
        
        // 1. Given - MockTickerService without ARS Exchange Rate
        
        // 2. When
        sut.loadInitialData()
        
        await Task.yield()
        
        // 3. Then
        let resultCurrencies = sut.state.currencies
        let containsARS = resultCurrencies.contains { $0.code == "ARS" }
        
        XCTAssertFalse(containsARS, "ARS should not be included in the filtered list")
        XCTAssertEqual(resultCurrencies.count, 3, "There should be 3 currencies after filtering ARS")
    }
}
