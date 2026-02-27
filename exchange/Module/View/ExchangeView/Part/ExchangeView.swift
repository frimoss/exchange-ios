//
//  ExchangeView.swift
//  exchange
//
//  Created by Nikolai on 05/02/2026.
//

import UIKit

final class ExchangeView: UIView {
    
    enum InputPosition {
        case top
        case bottom
    }
    
    // MARK: - Public
    
    var onSwapTap: (() -> Void)?
    var onCurrencySelect: ((InputPosition) -> Void)?
    
    // MARK: - UI Components
    
    private let topInputView = ExchangeInputView()
    private let bottomInputView = ExchangeInputView()
    private let swapButton = SwapButton()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupView() {
        addSubviews([topInputView, bottomInputView, swapButton])
    }
    
    private func setupActions() {
        
        // Top Input Currency Button Tapped
        topInputView.onCurrencyTap = { [weak self] in
            self?.onCurrencySelect?(.top)
        }
        
        // Bottom Input Currency Button Tapped
        bottomInputView.onCurrencyTap = { [weak self] in
            self?.onCurrencySelect?(.bottom)
        }
        
        // Swap Button Tapped
        swapButton.addTarget(self, action: #selector(swapButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // From Exchange Item View
            topInputView.topAnchor.constraint(equalTo: topAnchor),
            topInputView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topInputView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // Swap Button
            swapButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            swapButton.centerYAnchor.constraint(equalTo: topInputView.bottomAnchor, constant: 8),
            swapButton.widthAnchor.constraint(equalToConstant: 36),  // 24 + (6 * 2)
            swapButton.heightAnchor.constraint(equalToConstant: 36), // size + (border * 2)
            
            // To Exchange Item View
            bottomInputView.topAnchor.constraint(equalTo: topInputView.bottomAnchor, constant: 16), // spacing
            bottomInputView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomInputView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomInputView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with config: Configuration) {
        topInputView.configure(with: config.topConfig)
        bottomInputView.configure(with: config.bottomConfig)
    }
    
    // MARK: - Button Action
    
    @objc private func swapButtonTapped() {
        onSwapTap?()
    }
}

// MARK: - Configuration -

extension ExchangeView {
    struct Configuration {
        let topConfig: ExchangeInputView.Configuration
        let bottomConfig: ExchangeInputView.Configuration
    }
}
