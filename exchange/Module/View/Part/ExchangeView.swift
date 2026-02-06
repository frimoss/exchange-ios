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
    
    // MARK: - UI Components
    
    private let fromExchangeItemView: ExchangeItemView = {
        let view = ExchangeItemView(currency: "USDc", exchangeRate: "$9,990")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let toExchangeItemView: ExchangeItemView = {
        let view = ExchangeItemView(currency: "MXN", exchangeRate: "$184,065.59")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
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
        addSubview(fromExchangeItemView)
        addSubview(toExchangeItemView)
        addSubview(swapButton)
        
        swapButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // From Exchange Item View
            fromExchangeItemView.topAnchor.constraint(equalTo: topAnchor),
            fromExchangeItemView.leadingAnchor.constraint(equalTo: leadingAnchor),
            fromExchangeItemView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // Swap Button
            swapButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            swapButton.centerYAnchor.constraint(equalTo: fromExchangeItemView.bottomAnchor, constant: 8),
            swapButton.widthAnchor.constraint(equalToConstant: 36),  // 24 + (6 * 2)
            swapButton.heightAnchor.constraint(equalToConstant: 36), // size + (border * 2)
            
            // To Exchange Item View
            toExchangeItemView.topAnchor.constraint(equalTo: fromExchangeItemView.bottomAnchor, constant: 16), // spacing
            toExchangeItemView.leadingAnchor.constraint(equalTo: leadingAnchor),
            toExchangeItemView.trailingAnchor.constraint(equalTo: trailingAnchor),
            toExchangeItemView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - Button Action
    
    @objc private func buttonTapped() {
        onSwap?()
    }
}
