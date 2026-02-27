//
//  ExchangeViewController.swift
//  exchange
//
//  Created by Nikolai on 03/02/2026.
//

import UIKit

final class ExchangeViewController: UIViewController {
    
    // MARK: - ViewModel
    
    private let viewModel = ExchangeViewModel()
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Exchange calculator"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = UIColor(named: "textPrimary")
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let exchangeRateLabel: UILabel = {
        let label = UILabel()
        label.text = "1 USDc = 17.17 MXN"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor(named: "accentGreen")
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let exchangeView = ExchangeView()
    
    // MARK: - Stack Views
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            exchangeRateLabel,
            exchangeView
        ])
        stackView.axis = .vertical
        stackView.spacing = 8 // Between Labels
        stackView.setCustomSpacing(24, after: exchangeRateLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupBindings()
        setupActions()
        viewModel.loadInitialData()
    }
    
    // MARK: - Bindings
    
    private func setupBindings() {
        viewModel.onStateChanged = { [weak self] state in
            self?.render(state)
        }
    }
    
    // MARK: - Render
    
    private func render(_ state: ExchangeViewState) {
        
        // Check State
        switch state.status {
        case .isLoading:
            // TODO: isLoading - show loader?
            print("Status - Loading...")
            
        case .error(let message):
            // TODO: error - add alert
            print("Status - Error: \(message)")
        
        case .loaded(let currencies):
            // TODO: currencies?
            print("Status: .loaded")
        }
        
        // Update Exchange Rate Label
        if let currentRate = state.exchangeRate?.toCurrency() {
            
            let currentCode = state.selectedCurrency.code.uppercased()
            
            exchangeRateLabel.text = "1 USDc = \(currentRate) \(currentCode)"
        }
        
        // MARK: - Configure Input Fields
        
        let topInputConfig = ExchangeInputView.Configuration(
            currencyCode: state.topCurrency.code,
            amount: state.topAmount,
            isCurrencySelectionEnabled: state.direction == .selectedToUsd,
            onAmountChanged: { [weak self] newText in
                
                self?.viewModel.topAmountChanged(newText)
            }
        )
        
        let bottomInputConfig = ExchangeInputView.Configuration(
            currencyCode: state.bottomCurrency.code,
            amount: state.bottomAmount,
            isCurrencySelectionEnabled: state.direction == .usdToSelected,
            onAmountChanged: { [weak self] newText in
                
                self?.viewModel.bottomAmountChanged(newText)
            }
        )
        
        // Update Exchange Inputs
        let viewConfig = ExchangeView.Configuration(
            topConfig: topInputConfig,
            bottomConfig: bottomInputConfig
        )
        
        exchangeView.configure(with: viewConfig)
    }
    
    // MARK: - Setup

    private func setupView() {
        view.backgroundColor = UIColor(named: "backgroundPrimary")
        view.addSubview(mainStackView)
    }
    
    private func setupActions() {
        
        // Handle Swap Button Tap
        exchangeView.onSwapTap = { [weak self] in
            self?.viewModel.swapTapped()
        }
        
        // Handle Currency Button Tap
        exchangeView.onCurrencySelect = { [weak self] input in
            self?.presentCurrencyList()
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Main Stack Constraints
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    // MARK: - Button Action
    
    private func presentCurrencyList() {
        
        let listVC = CurrencyListViewController(
            currencies: viewModel.state.currencies,
            selectedCurrency: viewModel.state.selectedCurrency,
            onSelect: { [weak self] currency in
                self?.viewModel.currencySelected(currency)
            }
        )
        
        self.showSheet(title: "Choose currency", contentViewController: listVC)
    }
}

// MARK: - Extension UIViewController -

extension UIViewController {
    
    func showSheet(title: String, contentViewController: UIViewController) {
        let sheet = SheetViewController(title: title, contentViewController: contentViewController)
        present(sheet, animated: true)
    }
}
