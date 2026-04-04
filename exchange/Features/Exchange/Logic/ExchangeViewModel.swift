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
    
    // MARK: - Public
    
    var state = ExchangeViewState()
    
    // MARK: - Private Dependencies
    
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
                let (currencies, ratesDict) = try await fetchRequiredData()
                // 2. Validation
                let validCurrencies = try validate(currencies: currencies, with: ratesDict)
                // 3. Set State
                finalizeLoading(currencies: validCurrencies, rates: ratesDict, error: nil)
                
            } catch {
                print("Network Error: \(error)")
                print("\nNetwork Error Description: \(error.localizedDescription)")
                
                // Handle Error
                let finalError = ExchangeError.map(error)
                
                // Show Fallback Data to the User
                handleFallback(error: finalError)
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
    
    func errorShown() {
        updateState { $0.alertMessage = nil }
    }
    
    // MARK: - Private Loading Steps
    
    private func fetchRequiredData() async throws -> ([Currency], [String: Decimal]) {
        // Load Available Currencies
        let currencies = try await service.fetchAvailableCurrencies()
        let codes = currencies.map { $0.code } // [Currency] -> [String]
        
        // Load Rates
        let exchangeRates = try await service.fetchTickers(currencies: codes)
        
        // Convert to Dictionary Rates [currencyCode: exchangeRate]
        let rateDict = exchangeRates.reduce(into: [String:Decimal]()) { dict, rate in
            dict[rate.currencyCode] = rate.exchangeRate
        }
        
        return (currencies, rateDict)
    }
    
    private func validate(currencies: [Currency], with rates: [String: Decimal]) throws -> [Currency] {
        // Check if Currencies have their Rates
        let valid = currencies.filter { rates[$0.code] != nil}
        guard !valid.isEmpty else { throw ExchangeError.emptyResponse }
        
        return valid
    }
    
    private func finalizeLoading(currencies: [Currency], rates: [String: Decimal], error: ExchangeError?) {
        updateState { newState in
            newState.currencies = currencies
            newState.rates = rates
            newState.status = .loaded
            newState.alertMessage = error?.errorDescription
            
            // Check Selected Currency exist
            if !currencies.contains(where: { $0.code == newState.selectedCurrency.code }) {
                newState.selectedCurrency = currencies.first ?? newState.selectedCurrency
            }
            
            self.syncAmounts(in: &newState)
        }
    }
    
    private func handleFallback(error: ExchangeError) {
        finalizeLoading(
            currencies: Currency.mockCurrencies,
            rates: ExchangeRate.mockDictRates,
            error: error
        )
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
