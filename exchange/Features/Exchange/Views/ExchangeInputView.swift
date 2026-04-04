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
    
    private let currencyAreaButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let countryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.font = AppStyle.Typography.body
        label.textColor = AppStyle.Color.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let chooseCurrencyChevronImageView: UIImageView = {
        let imageView = UIImageView()
        let configuration = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        imageView.image = UIImage(systemName: "chevron.down", withConfiguration: configuration)
        imageView.tintColor = AppStyle.Color.textPrimary
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let amountTextField: AmountTextField = {
        let textField = AmountTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
            
        return textField
    }()
    
    // MARK: - Stack Views
    
    private lazy var currencyStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            countryImageView,
            currencyLabel,
            chooseCurrencyChevronImageView
        ])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private lazy var mainStackView: UIStackView = {
        let spacer = UIView()
        spacer.isUserInteractionEnabled = false
        
        let stack = UIStackView(arrangedSubviews: [
            currencyStackView,
            spacer,
            amountTextField
        ])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
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
        backgroundColor = AppStyle.Color.backgroundSecondary
        layer.cornerRadius = AppStyle.Metrics.cornerRadius
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainStackView)
        mainStackView.addSubview(currencyAreaButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Fixed Height of Component
            heightAnchor.constraint(equalToConstant: 66),
            
            // Flag Image Size
            countryImageView.widthAnchor.constraint(equalToConstant: 20),
            countryImageView.heightAnchor.constraint(equalToConstant: 20),
            
            // Main Stack View
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AppStyle.Metrics.horizontalPadding),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AppStyle.Metrics.horizontalPadding),
            mainStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            // Currency Area Button
            currencyAreaButton.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            currencyAreaButton.topAnchor.constraint(equalTo: mainStackView.topAnchor),
            currencyAreaButton.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor),
            currencyAreaButton.trailingAnchor.constraint(equalTo: currencyStackView.trailingAnchor),
        ])
    }
    
    private func setupActions() {
        // Choose Currency Button Tapped
        currencyAreaButton.addTarget(self, action: #selector(currencyButtonTapped), for: .touchUpInside)
        
        // Handle Amount Changed
        amountTextField.addTarget(self, action: #selector(handleEditingChanged), for: .editingChanged)
        
        // TextField Focus by Tap
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleViewTap))
        addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    
    @objc private func currencyButtonTapped() {
        onCurrencyTap?()
    }
    
    @objc private func handleEditingChanged() {
        textChangeHandler?(amountTextField.text ?? "")
    }
    
    @objc private func handleViewTap() {
        amountTextField.becomeFirstResponder()
    }
    
    // MARK: - Configuration
    
    func configure(with config: Configuration) {
        updateCurrencyUI(config)
        updateAmount(config.amount)
    }
    
    private func updateCurrencyUI(_ config: Configuration) {
        currencyLabel.text = config.currencyCode
        countryImageView.image = UIImage(named: config.currencyCode)
        currencyAreaButton.isEnabled = config.isCurrencySelectionEnabled
        chooseCurrencyChevronImageView.isHidden = !config.isCurrencySelectionEnabled
        
        // Handle Amount Changed
        self.textChangeHandler = config.onAmountChanged
    }
    
    private func updateAmount(_ amount: String) {
        guard !amountTextField.isFirstResponder else {
            if amountTextField.text != amount { amountTextField.text = amount }
            return
        }
        amountTextField.text = AmountParser.parse(amount)?.toCurrency()
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
