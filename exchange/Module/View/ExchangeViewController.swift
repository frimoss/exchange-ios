//
//  ExchangeViewController.swift
//  exchange
//
//  Created by Nikolai on 03/02/2026.
//

import UIKit

class ExchangeViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Exchange calculator"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = UIColor(named: "primary")
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let exchangeRateLabel: UILabel = {
        let label = UILabel()
        label.text = "1 USDc = 18.4097 MXN"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor(named: "green")
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

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    // MARK: - Setup

    private func setupView() {
        view.backgroundColor = UIColor(named: "bgColor")
        view.addSubview(mainStackView)
        
        // Handle Swap Button tap
        exchangeView.onSwap = { [weak self] in
            self?.handleSwapButtonTap()
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
    
    private func handleSwapButtonTap() {
        print("Swap button tapped")
    }
}
