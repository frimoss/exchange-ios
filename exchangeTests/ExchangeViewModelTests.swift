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

    // MARK: - SUT

    private var sut: ExchangeViewModel!
    private var mockService: MockTickerService!

    // MARK: - Lifecycle

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockService = MockTickerService()
        sut = ExchangeViewModel(service: mockService)
    }

    override func tearDown() async throws {
        sut = nil
        mockService = nil
        try await super.tearDown()
    }
    
    // MARK: - Group 1: Fetching Data & Error Handling -

    // Successful Data Load sets Status = .loaded and correct Currency count
    func test_loadInitialData_success_setsLoadedStatus() async throws {
        // Given
        mockService.mockCurrencies = [Currency(code: "BRL"), Currency(code: "MXN")]
        mockService.mockRates = [
            ExchangeRate(ask: "17.1703", bid: "17.1671", book: "usdc_mxn", date: ""),
            ExchangeRate(ask: "5.2589",  bid: "5.2065",  book: "usdc_brl", date: "")
        ]

        // When
        sut.loadInitialData()
        await Task.yield()

        // Then
        guard case .loaded = sut.state.status else {
            return XCTFail("Expected .loaded status, got \(sut.state.status)")
        }
        XCTAssertEqual(sut.state.currencies.count, 2)
    }

    // Currencies without matching Exchange Rates are excluded from State
    func test_loadInitialData_filtersCurrenciesWithoutRates() async throws {
        // Given
        mockService.mockCurrencies = [Currency(code: "MXN"), Currency(code: "ARS")]
        mockService.mockRates = [
            ExchangeRate(ask: "17.1703", bid: "17.1671", book: "usdc_mxn", date: "")
        ]

        // When
        sut.loadInitialData()
        await Task.yield()

        // Then
        let codes = sut.state.currencies.map { $0.code }
        XCTAssertEqual(codes, ["MXN"], "Only MXN should remain after filtering")
        XCTAssertFalse(codes.contains("ARS"))
    }
    
    //  No valid Currencies after filtering sets ExchangeError = .emptyResponse and User Message
    func test_loadInitialData_emptyValidCurrencies_setsAlertMessage() async throws {
        // Given
        mockService.mockCurrencies = [Currency(code: "BTC")]
        mockService.mockRates = [] // Empty Rates
        let expectedMessage = ExchangeError.emptyResponse.errorDescription

        // When
        sut.loadInitialData()
        await Task.yield()

        // Then
        XCTAssertEqual(sut.state.alertMessage, expectedMessage)
        XCTAssertEqual(sut.state.status, .loaded)
    }
    
    // Simulating an Apple Error "No Internet Сonnection"
    func test_loadInitialData_offlineError_setsOfflineAlertMessage() async throws {
        // Given
        mockService.stubbedError = URLError(.notConnectedToInternet)
        let expectedMessage = ExchangeError.offline.errorDescription

        // When
        sut.loadInitialData()
        await Task.yield()

        // Then
        XCTAssertEqual(sut.state.alertMessage, expectedMessage)
        XCTAssertEqual(sut.state.status, .loaded)
    }
    
    // Simulating Server Error (500 or Timeout)
    func test_loadInitialData_serverError_setsServerErrorAlertMessage() async throws {
        // Given
        mockService.stubbedError = NetworkError.serverError(statusCode: 500)
        let expectedMessage = ExchangeError.serverError.errorDescription

        // When
        sut.loadInitialData()
        await Task.yield()

        // Then
        XCTAssertEqual(sut.state.alertMessage, expectedMessage)
        XCTAssertEqual(sut.state.status, .loaded)
    }
    
    // Alert Message Must be nil after it is shown to User
    func test_dismissAlert_clearsMessage() {
        // Given
        sut.state.alertMessage = "Error message for User"
        
        // When
        sut.errorShown()
        
        // Then
        XCTAssertNil(sut.state.alertMessage)
    }

    // MARK: - Group 2: Calculation Logic -

    // Typing in Top Field (USD) Recalculate Bottom Field (MXN)
    func test_topAmountChanged_updatesBottomAmount() {
        // Given
        sut.state.rates = ["MXN": 20.0]
        sut.state.direction = .usdToSelected

        // When
        sut.topAmountChanged("10")

        // Then
        XCTAssertEqual(sut.state.bottomAmount, "200", "10 USD * 20 = 200 MXN")
    }

    // Typing in Bottom Field (MXN) Recalculate Top Field (USD)
    func test_bottomAmountChanged_updatesTopAmount() {
        // Given
        sut.state.rates = ["MXN": 20.0]
        sut.state.direction = .usdToSelected

        // When
        sut.bottomAmountChanged("100")

        // Then
        XCTAssertEqual(sut.state.topAmount, "5", "100 MXN / 20 = 5 USD")
    }

    // Empty input in Top Field sets Bottom amount to "0"
    func test_topAmountChanged_emptyInput_returnsZero() {
        sut.topAmountChanged("")
        XCTAssertEqual(sut.state.bottomAmount, "0")
    }
    
    // MARK: - Group 3: User Interactions & UI Flow -

    // Swap Reverses Direction and Recalculate Amounts
    func test_swapTapped_reversesDirectionAndRecalculates() {
        // Given
        sut.state.rates = ["MXN": 20.0]
        sut.state.topAmount = "1"
        sut.state.direction = .usdToSelected
        sut.state.activeField = .top

        // When
        sut.swapTapped()

        // Then
        XCTAssertEqual(sut.state.direction, .selectedToUsd)
        XCTAssertEqual(sut.state.bottomAmount, "0.05", "1 MXN / 20 = 0.05 USD")
    }

    // Selecting a Currency Updates the Exchange Rate and Recalculates Bottom Amount
    func test_currencySelected_updatesRateAndRecalculates() {
        // Given
        sut.state.rates = ["MXN": 20.0, "USD": 0.9]
        sut.state.topAmount = "100"
        sut.state.activeField = .top
        sut.state.direction = .usdToSelected

        // When
        sut.currencySelected(Currency(code: "USD"))

        // Then
        XCTAssertEqual(sut.state.bottomAmount, "90", "100 / 0.9 = 90")
    }

    // Non-numeric Input is rejected and Bottom Amount is set to Empty
    func test_topAmountChanged_nonNumericInput_returnsEmpty() {
        // Given
        sut.state.rates = ["MXN": 20.0]

        // When
        sut.topAmountChanged("text")

        // Then
        XCTAssertEqual(sut.state.bottomAmount, "")
    }
}
