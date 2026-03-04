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
    
    // MARK: - Load
    
    func loadInitialData() {
        Task {
            state.status = .isLoading
            
            do {
                // Load Available Currencies
                let currencies = try await service.fetchAvailableCurrencies()
                
                // Load All Tickers
                let codes = currencies.map { $0.code } // [Currency] -> [String]
                let exchangeRates = await service.fetchTickersWithFallback(currencies: codes)
                
                // Create new State
                var newState = state
                
                // Convert to Dictionary Rates [currencyCode: exchangeRate]
                newState.rates = exchangeRates.reduce(into: [:]) { dict, rate in
                    dict[rate.currencyCode] = rate.exchangeRate
                }
                
                // State
                newState.currencies = currencies
                
                // Calculate bottom Amount (by default)
                let calculated = calculateOpposite(from: newState.topAmount, state: newState, sourceIsTop: true)
                newState.bottomAmount = calculated
                
                newState.status = .loaded(currencies)
                
                // Update State - 1 Time
                self.state = newState
                
            } catch {
                state.status = .error("Failed to sync Rates")
            }
        }
    }
    
    // MARK: - User Actions
    
    func topAmountChanged(_ text: String) {
        var newState = state
        
        newState.activeField = .top
        newState.topAmount = text
        newState.bottomAmount = calculateOpposite(from: text, state: newState, sourceIsTop: true)
        
        self.state = newState
    }
    
    func bottomAmountChanged(_ text: String) {
        var newState = state
        
        newState.activeField = .bottom
        newState.bottomAmount = text
        newState.topAmount = calculateOpposite(from: text, state: newState, sourceIsTop: false)
        
        self.state = newState
    }
    
    func swapTapped() {
        var newState = state
        
        newState.direction = (state.direction == .usdToSelected) ? .selectedToUsd : .usdToSelected
        
        // Recalculate
        let (updatedTop, updatedBottom) = recalculate(for: newState)
        newState.topAmount = updatedTop
        newState.bottomAmount = updatedBottom
        
        self.state = newState
    }
    
    func currencySelected(_ currency: Currency) {
        var newState = state
        
        newState.selectedCurrency = currency
        
        // Recalculate
        let (updatedTop, updatedBottom) = recalculate(for: newState)
        newState.topAmount = updatedTop
        newState.bottomAmount = updatedBottom
        
        self.state = newState
    }
    
    // MARK: - Private Calculations -
    
    private func recalculate(for targetState: ExchangeViewState) -> (top: String, bottom: String) {
        
        var top = targetState.topAmount
        var bottom = targetState.bottomAmount
        
        switch state.activeField {
        case .top:
            bottom = calculateOpposite(from: targetState.topAmount, state: targetState, sourceIsTop: true)
        case .bottom:
            top = calculateOpposite(from: targetState.bottomAmount, state: targetState, sourceIsTop: false)
        }
        
        return (top, bottom)
    }
    
    private func calculateOpposite(from text: String, state: ExchangeViewState, sourceIsTop: Bool) -> String {
        
        // Check User's Input
        guard !text.isEmpty else { return "" }
        
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
