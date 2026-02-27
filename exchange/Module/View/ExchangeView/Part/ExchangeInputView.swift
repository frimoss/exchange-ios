//
//  ExchangeInputView.swift
//  exchange
//
//  Created by Nikolai on 05/02/2026.
//

import UIKit

final class ExchangeInputView: UIView {
    
    // MARK: - Public
    
    var onCurrencyTap: (() -> Void)?
    
    // MARK: - Private Properties
    
    private var textChangeHandler: ((String) -> Void)?

    // MARK: - UI Components
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor(named: "textPrimary")
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "0"
        textField.font = .systemFont(ofSize: 16, weight: .bold)
        textField.textColor = UIColor(named: "textPrimary")
        
        // Keyboard
        textField.keyboardType = .decimalPad
        textField.textAlignment = .left
        
        // Correction
        textField.autocorrectionType = .no
        
        // TextField Style
        textField.borderStyle = .none
        //textField.backgroundColor = .clear
        
        textField.translatesAutoresizingMaskIntoConstraints = false
            
        return textField
    }()
    
    private let chooseCurrencyButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        button.setImage(UIImage(systemName: "chevron.down", withConfiguration: configuration), for: .normal)
        button.tintColor = UIColor(named: "textPrimary")
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
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
        backgroundColor = .white
        layer.cornerRadius = 16
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews([currencyLabel, chooseCurrencyButton, amountTextField])
    }
    
    private func setupActions() {
        chooseCurrencyButton.addTarget(self, action: #selector(currencyButtonTapped), for: .touchUpInside)
        
        amountTextField.addTarget(self, action: #selector(handleEditingChanged), for: .editingChanged)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Height constraint
            heightAnchor.constraint(equalToConstant: 66),
            
            // Currency Label
            currencyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            currencyLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            chooseCurrencyButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            chooseCurrencyButton.leadingAnchor.constraint(equalTo: currencyLabel.trailingAnchor, constant: 8),
            
            // Exchange Rate Label
            amountTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            amountTextField.centerYAnchor.constraint(equalTo: centerYAnchor),
            amountTextField.leadingAnchor.constraint(greaterThanOrEqualTo: chooseCurrencyButton.trailingAnchor, constant: 16)
        ])
    }
    
    // MARK: - Configuration
        
    func configure(with config: Configuration) {
        
        currencyLabel.text = config.currencyCode
        chooseCurrencyButton.isHidden = !config.isCurrencySelectionEnabled
        
        self.textChangeHandler = config.onAmountChanged
        
        // Update Amount only if changed
        if amountTextField.text != config.amount {
            amountTextField.text = config.amount
        }
    }
    
    // MARK: - Button Action
    
    @objc private func currencyButtonTapped() {
        onCurrencyTap?()
    }
    
    @objc private func handleEditingChanged() {
        textChangeHandler?(amountTextField.text ?? "")
    }
}

// MARK: - ExchangeInputView Configuration -

extension ExchangeInputView {
    struct Configuration {
        let currencyCode: String
        let amount: String
        let isCurrencySelectionEnabled: Bool
        let onAmountChanged: (String) -> Void
    }
}
