//
//  ExchangeErrorTests.swift
//  exchangeTests
//
//  Created by Nikolai on 04/04/2026.
//

import XCTest
@testable import exchange

@MainActor
final class ExchangeErrorTests: XCTestCase {

    // MARK: - Group 1: Mapping from ExchangeError -
    
    func test_map_alreadyExchangeError_returnsSameCase() {
        let originalError = ExchangeError.offline
        let mappedError = ExchangeError.map(originalError)
        
        XCTAssertEqual(mappedError, .offline)
    }
    
    // MARK: - Group 2: Mapping from NetworkError -
    
    func test_map_networkNoData_returnsEmptyResponse() {
        let netError = NetworkError.noData
        let mapped = ExchangeError.map(netError)
        
        XCTAssertEqual(mapped, .emptyResponse)
    }
    
    func test_map_networkDecodingFailed_returnsEmptyResponse() {
        let netError = NetworkError.decodingFailed
        let mapped = ExchangeError.map(netError)
        
        XCTAssertEqual(mapped, .emptyResponse)
    }
    
    func test_map_networkServerError_returnsServerError() {
        let netError = NetworkError.serverError(statusCode: 500)
        let mapped = ExchangeError.map(netError)
        
        XCTAssertEqual(mapped, .serverError)
    }
    
    // MARK: - Group 3: Mapping from URLError (URLSession) -
    
    func test_map_urlNotConnectedToInternet_returnsOffline() {
        let urlError = URLError(.notConnectedToInternet)
        let mapped = ExchangeError.map(urlError)
        
        XCTAssertEqual(mapped, .offline)
    }
    
    func test_map_urlTimedOut_returnsServerError() {
        let urlError = URLError(.timedOut)
        let mapped = ExchangeError.map(urlError)
        
        XCTAssertEqual(mapped, .serverError)
    }
    
    // MARK: - Group 4: Unknown Errors -
    
    func test_map_anyRandomError_returnsUnknown() {
        struct RandomError: Error {}
        let mapped = ExchangeError.map(RandomError())
        
        if case .unknown = mapped {
            // Success
        } else {
            XCTFail("Expected .unknown case")
        }
    }
    
    // MARK: - Group 5: Descriptions (User View) -
    
    func test_errorDescription_offline_isCorrect() {
        let error = ExchangeError.offline
        let expected = "You appear to be offline. Please check your Internet connection. Using outdated rates."
        
        XCTAssertEqual(error.errorDescription, expected)
    }
    
    func test_errorDescription_serverError_isCorrect() {
        let error = ExchangeError.serverError
        let expected = "Our service is temporarily unavailable. Using outdated rates."
        
        XCTAssertEqual(error.errorDescription, expected)
    }
    
    func test_allErrorCases_haveNonEmptyDescriptions() {
        let allCases: [ExchangeError] = [
            .emptyResponse,
            .offline,
            .serverError,
            .unknown(URLError(.badURL))
        ]
        
        for error in allCases {
            XCTAssertFalse(error.errorDescription?.isEmpty ?? true, "Description for \(error) should not be empty")
        }
    }
}
