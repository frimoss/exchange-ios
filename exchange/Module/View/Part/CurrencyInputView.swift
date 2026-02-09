//
//  CurrencyInputView.swift
//  exchange
//
//  Created by Nikolai on 05/02/2026.
//

import UIKit

final class CurrencyInputView: UIView {
    
    // MARK: - Properties
    
    var onCurrencyTap: (() -> Void)?

    // MARK: - UI Components
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.text = "USDc"
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
        
        // Dollar Currency
        let dollarLabel = UILabel()
        dollarLabel.text = "$"
        dollarLabel.font = .systemFont(ofSize: 16, weight: .bold)
        dollarLabel.textColor = UIColor(named: "textPrimary")
        dollarLabel.sizeToFit()
        
        textField.leftView = dollarLabel
        textField.leftViewMode = .always
        
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
    
    init(currency: String = "USDc", amount: String, showButton: Bool = false) {
        super.init(frame: .zero)
        
        // Properties
        currencyLabel.text = currency
        amountTextField.text = amount
        
        // UI
        setupView()
        setupConstraints()
        
        chooseCurrencyButton.isHidden = !showButton
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 16
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(currencyLabel)
        addSubview(chooseCurrencyButton)
        addSubview(amountTextField)
        
        chooseCurrencyButton.addTarget(self, action: #selector(currencyButtonTapped), for: .touchUpInside)
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
    
    // MARK: - Public Methods
    
    func configure(currency: String, amount: String) {
        currencyLabel.text = currency
        amountTextField.text = amount
    }
    
    // MARK: - Button Action
    
    @objc private func currencyButtonTapped() {
        onCurrencyTap?()
    }
}
