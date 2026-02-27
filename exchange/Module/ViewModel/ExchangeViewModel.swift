//
//  ExchangeViewModel.swift
//  exchange
//
//  Created by Nikolai on 19/02/2026.
//

import Foundation

@MainActor
final class ExchangeViewModel {
    
    // MARK: - State
    
    private(set) var state = ExchangeViewState() {
        didSet { onStateChanged?(state) }
    }
    
    var onStateChanged: ((ExchangeViewState) -> Void)? // Closure
    
    // MARK: - Dependencies
    
    private let service = TickerService()
    //private let service = TickerService(client: MockNetworkClient())
    
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
                
                // Convert to Dictionary Rates [currencyCode: exchangeRate]
                state.rates = exchangeRates.reduce(into: [:]) { dict, rate in
                    dict[rate.currencyCode] = rate.exchangeRate
                }
                
                // State
                state.currencies = currencies
                
                recalculate() // Calculate bottom Amount (by default)
                
                state.status = .loaded(currencies)
                
            } catch {
                state.status = .error("Failed to sync Rates")
            }
        }
    }
    
    // MARK: - User Actions
    
    func topAmountChanged(_ text: String) {
        state.activeField = .top
        state.topAmount = text
        state.bottomAmount = calculateOpposite(from: text, sourceIsTop: true)
    }
    
    func bottomAmountChanged(_ text: String) {
        state.activeField = .bottom
        state.bottomAmount = text
        state.topAmount = calculateOpposite(from: text, sourceIsTop: false)
    }
    
    func swapTapped() {
        state.direction = (state.direction == .usdToSelected) ? .selectedToUsd : .usdToSelected
        recalculate()
    }
    
    func currencySelected(_ currency: Currency) {
        state.selectedCurrency = currency
        recalculate()
    }
    
    // MARK: - Private Calculations -
    
    private func recalculate() {
        switch state.activeField {
        case .top:
            state.bottomAmount = calculateOpposite(from: state.topAmount, sourceIsTop: true)
        case .bottom:
            state.topAmount = calculateOpposite(from: state.bottomAmount, sourceIsTop: false)
        }
    }
    
    private func calculateOpposite(from text: String, sourceIsTop: Bool) -> String {
        
        // Check User's Input
        guard !text.isEmpty else { return "" }
        
        // Decimal Accepts only Number with dot: 1,5 -> 1.5
        let normalized = text.replacingOccurrences(of: ",", with: ".")
        
        // Check Amount & Exchange Rate
        guard
            let amount = Decimal(string: normalized),
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
