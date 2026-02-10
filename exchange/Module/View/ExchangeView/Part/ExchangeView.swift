//
//  ExchangeView.swift
//  exchange
//
//  Created by Nikolai on 05/02/2026.
//

import UIKit

final class ExchangeView: UIView {
    
    // MARK: - Properties
    
    var onSwap: (() -> Void)?
    var showCurrencySheet: (() -> Void)?
    
    // MARK: - UI Components
    
    private let fromCurrencyView = ExchangeInputView(currency: "USDc", amount: "9,990.90")
    
    private let toCurrencyView = ExchangeInputView(currency: "MXN", amount: "184,065.59", showButton: true)
    
    private let swapButton = SwapButton()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        addSubview(fromCurrencyView)
        addSubview(toCurrencyView)
        addSubview(swapButton)
        
        swapButton.addTarget(self, action: #selector(swapButtonTapped), for: .touchUpInside)
        
        // Handle Currency Tap
        toCurrencyView.onCurrencyTap = { [weak self] in
            self?.showCurrencySheet?()
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // From Exchange Item View
            fromCurrencyView.topAnchor.constraint(equalTo: topAnchor),
            fromCurrencyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            fromCurrencyView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // Swap Button
            swapButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            swapButton.centerYAnchor.constraint(equalTo: fromCurrencyView.bottomAnchor, constant: 8),
            swapButton.widthAnchor.constraint(equalToConstant: 36),  // 24 + (6 * 2)
            swapButton.heightAnchor.constraint(equalToConstant: 36), // size + (border * 2)
            
            // To Exchange Item View
            toCurrencyView.topAnchor.constraint(equalTo: fromCurrencyView.bottomAnchor, constant: 16), // spacing
            toCurrencyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            toCurrencyView.trailingAnchor.constraint(equalTo: trailingAnchor),
            toCurrencyView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - Button Action
    
    @objc private func swapButtonTapped() {
        onSwap?()
    }
}
