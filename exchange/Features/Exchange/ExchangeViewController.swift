//
//  ExchangeViewController.swift
//  exchange
//
//  Created by Nikolai on 03/02/2026.
//

import UIKit

final class ExchangeViewController: UIViewController {
    
    // MARK: - Dependencies
    
    private let viewModel: ExchangeViewModel
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Exchange calculator"
        label.font = AppStyle.Typography.header
        label.textColor = AppStyle.Color.textPrimary
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let exchangeRateLabel: UILabel = {
        let label = UILabel()
        label.font = AppStyle.Typography.body
        label.textColor = AppStyle.Color.accent
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let exchangeView = ExchangeView()
    
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
    
    // Haptic Feedback on Swap Button
    private let haptic = UIImpactFeedbackGenerator(style: .light)
    
    // MARK: - Properties
    
    private var lastShownError: String?
    
    // MARK: - Init
    
    init(viewModel: ExchangeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupObservation()
        setupActions()
        viewModel.loadInitialData()
        setupKeyboardDismissGesture()
    }
    
    // MARK: - Observation
    
    private func setupObservation() {
        withObservationTracking {
            // Call Render VC by State
            render(viewModel.state)
            
        } onChange: { [weak self] in
            // Safe: Put in the Main Thread
            Task { @MainActor [weak self] in
                // Run SetupObservation() again
                self?.setupObservation()
            }
        }
    }
    
    // MARK: - Render
    
    private func render(_ state: ExchangeViewState) {
        switch state.status {
        case .isLoading:
            setLoading(true)
            
        case .error(let message):
            setLoading(false)
            showErrorAlert(message)
            print("Status - Error: \(message)")
            return // Stop here if Error
        
        case .loaded:
            setLoading(false)
            print("Status - Loaded")
        }
        
        updateExchangeRate(state)
        updateInputFields(state)
    }
    
    private func setLoading(_ isLoading: Bool) {
        view.isUserInteractionEnabled = !isLoading
        print("Status - Loading...")
    }
    
    // MARK: - Update Exchange Rate Label
    
    private func updateExchangeRate(_ state: ExchangeViewState) {
        guard let rate = state.exchangeRate else { return }
        let code = state.selectedCurrency.code.uppercased()
        
        exchangeRateLabel.text = "1 USDc = \(rate.toCurrency()) \(code)"
    }
    
    // MARK: - Configure Input Fields
    
    private func updateInputFields(_ state: ExchangeViewState) {
        let viewConfig = ExchangeView.Configuration(
            topConfig: makeTopConfig(state),
            bottomConfig: makeBottomConfig(state),
            isSwapLoading: state.status == .isLoading
        )
        
        exchangeView.configure(with: viewConfig)
    }
    
    private func makeTopConfig(_ state: ExchangeViewState) -> ExchangeInputView.Configuration {
        .init(
            currencyCode: state.topCurrency.code,
            amount: state.topAmount,
            isCurrencySelectionEnabled: state.direction == .selectedToUsd,
            onAmountChanged: { [weak self] newAmount in
                self?.viewModel.topAmountChanged(newAmount)
            }
        )
    }
    
    private func makeBottomConfig(_ state: ExchangeViewState) -> ExchangeInputView.Configuration {
        .init(
            currencyCode: state.bottomCurrency.code,
            amount: state.bottomAmount,
            isCurrencySelectionEnabled: state.direction == .usdToSelected,
            onAmountChanged: { [weak self] newAmount in
                self?.viewModel.bottomAmountChanged(newAmount)
            }
        )
    }
    
    // MARK: - Setup

    private func setupView() {
        view.backgroundColor = AppStyle.Color.backgroundPrimary
        view.addSubview(mainStackView)
    }
    
    private func setupActions() {
        // Prepare Haptic
        haptic.prepare()
        
        // Handle Swap Button Tap
        exchangeView.onSwapTap = { [weak self] in
            guard let self else { return }
            self.haptic.impactOccurred()
            self.viewModel.swapTapped()
            self.haptic.prepare()
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
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: AppStyle.Metrics.horizontalPadding),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -AppStyle.Metrics.horizontalPadding),
            
            // Fixed Height for Exchange Rate Label
            exchangeRateLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20)
        ])
    }
    
    // MARK: - Actions
    
    private func presentCurrencyList() {
        // Build ListVC via Assembly
        let listVC = CurrencyListAssembly.build(
            currencies: viewModel.state.currencies,
            selectedCurrency: viewModel.state.selectedCurrency,
            onSelect: { [weak self] currency in
                self?.viewModel.currencySelected(currency)
            }
        )
        
        self.showSheet(title: "Choose currency", contentViewController: listVC)
    }
    
    private func showErrorAlert(_ message: String) {
        // Prevent double Alert
        guard lastShownError != message else { return }
        lastShownError = message
        
        // Create Alert
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default) { [weak self] _ in
            self?.lastShownError = nil
        })
        
        // Show Alert
        present(alert, animated: true)
    }
    
    private func setupKeyboardDismissGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
}

// MARK: - Extension UIViewController -

extension UIViewController {
    
    func showSheet(title: String, contentViewController: UIViewController) {
        let sheet = SheetViewController(title: title, contentViewController: contentViewController)
        present(sheet, animated: true)
    }
}
