//
//  ExchangeViewModel.swift
//  exchange
//
//  Created by Nikolai on 19/02/2026.
//

import Foundation

@MainActor
@Observable
final class ExchangeViewModel {
    
    // MARK: - State
    
    var state = ExchangeViewState()
    
    // MARK: - Dependencies
    
    private let service: TickerServiceProtocol
    
    // MARK: - Init
    
    init(service: TickerServiceProtocol) {
        self.service = service
    }
    
    // MARK: - Public Actions
    
    func loadInitialData() {
        Task {
            updateState { $0.status = .isLoading }
            
            do {
                // 1. Load Raw Data
                let (currencies, rates) = try await fetchRequiredData()
                
                // 2. Validation
                let validCurrencies = try validate(currencies: currencies, with: rates)
                
                // 3. Set State
                updateState { newState in
                    newState.rates = rates
                    newState.currencies = validCurrencies
                    
                    // Check default Currency exist
                    if !validCurrencies.contains(where: { $0.code == newState.selectedCurrency.code }) {
                        newState.selectedCurrency = validCurrencies.first ?? newState.selectedCurrency
                    }
                    
                    newState.status = .loaded(validCurrencies)
                    self.syncAmounts(in: &newState)
                }
            } catch {
                updateState { $0.status = .error("Failed to sync Rates") }
            }
        }
    }
    
    func topAmountChanged(_ text: String) {
        updateState { newState in
            newState.activeField = .top
            newState.topAmount = text
            newState.bottomAmount = calculateOpposite(from: text, state: newState, sourceIsTop: true)
        }
    }
    
    func bottomAmountChanged(_ text: String) {
        updateState { newState in
            newState.activeField = .bottom
            newState.bottomAmount = text
            newState.topAmount = calculateOpposite(from: text, state: newState, sourceIsTop: false)
        }
    }
    
    func swapTapped() {
        updateState { newState in
            newState.direction = (state.direction == .usdToSelected) ? .selectedToUsd : .usdToSelected
            self.syncAmounts(in: &newState)
        }
    }
    
    func currencySelected(_ currency: Currency) {
        updateState { newState in
            newState.selectedCurrency = currency
            self.syncAmounts(in: &newState)
        }
    }
    
    // MARK: - Private Loading Steps
    
    private func fetchRequiredData() async throws -> ([Currency], [String: Decimal]) {
        // Load Available Currencies
        let currencies = try await service.fetchAvailableCurrencies()
        let codes = currencies.map { $0.code } // [Currency] -> [String]
        
        // Load Rates
        let exchangeRates = await service.fetchTickersWithFallback(currencies: codes)
        
        // Convert to Dictionary Rates [currencyCode: exchangeRate]
        let rateDict = exchangeRates.reduce(into: [String:Decimal]()) { dict, rate in
            dict[rate.currencyCode] = rate.exchangeRate
        }
        
        return (currencies, rateDict)
    }
    
    private func validate(currencies: [Currency], with rates: [String: Decimal]) throws -> [Currency] {
        // Check if Currencies have their Rates
        let valid = currencies.filter { rates[$0.code] != nil}
        guard !valid.isEmpty else { throw ExchangeError.noRatesAvailable }
        
        return valid
    }
    
    // MARK: - Private Helpers
    
    private func updateState(_ modification: (inout ExchangeViewState) -> Void) {
        var newState = self.state
        modification(&newState)
        self.state = newState
    }
    
    /// General logic of re-calculation when changing the Currency or Direction
    private func syncAmounts(in newState: inout ExchangeViewState) {
        switch newState.activeField {
        case .top:
            newState.bottomAmount = calculateOpposite(from: newState.topAmount, state: newState, sourceIsTop: true)
        case .bottom:
            newState.topAmount = calculateOpposite(from: newState.bottomAmount, state: newState, sourceIsTop: false)
        }
    }
    
    private func calculateOpposite(from text: String, state: ExchangeViewState, sourceIsTop: Bool) -> String {
        // Check User's Input
        guard !text.isEmpty else { return "0" }
        
        // Delete all spaces from Input
        let cleanText = text.components(separatedBy: .whitespaces).joined()
        
        // Check Amount & Exchange Rate
        guard
            let amount = Decimal(string: cleanText, locale: .current),
            amount > 0,
            let rate = state.exchangeRate,
            rate > 0
        else { return "" }
        
        let result: Decimal
        
        switch state.direction {
        case .usdToSelected:
            //  SourceIsTop: USD to MXN (amount * rate)
            result = sourceIsTop ? amount * rate : amount / rate
        
        case .selectedToUsd:
            // !SourceIsTop: MXN to USD (amount / rate)
            result = sourceIsTop ? amount / rate : amount * rate
        }
        
        return result.toCurrency()
    }
}
