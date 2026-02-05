//
//  ExchangeViewController.swift
//  exchange
//
//  Created by Nikolai on 03/02/2026.
//

import UIKit

class ExchangeViewController: UIViewController {
    
    // Label, Label, TextField, Button TextField, Sheet
    
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
    
    private let fromExchangeItemView = ExchangeItemView(currency: "USDc", exchangeRate: "$9,990")
    private let toExchangeItemView = ExchangeItemView(currency: "MXN", exchangeRate: "$184,065.59")
    
    // MARK: - Stack Views
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            exchangeRateLabel,
            fromExchangeItemView,
            toExchangeItemView
        ])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        //stackView.backgroundColor = .gray
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = UIColor(named: "bgColor")
        view.addSubview(mainStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            // Main Stack Constraints
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
}
