//
//  ExchangeItemView.swift
//  exchange
//
//  Created by Nikolai on 05/02/2026.
//

import UIKit

final class ExchangeItemView: UIView {

    // MARK: - UI Components
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.text = "USDc"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor(named: "primary")
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let exchangeRateLabel: UILabel = {
        let label = UILabel()
        label.text = "$9,999"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(named: "primary")
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    convenience init(currency: String, exchangeRate: String) {
        self.init(frame: .zero)
        
        currencyLabel.text = currency
        exchangeRateLabel.text = exchangeRate
    }
    
    // MARK: - Setup
    
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 16
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(currencyLabel)
        addSubview(exchangeRateLabel)
        
        NSLayoutConstraint.activate([
            // Height constraint
            heightAnchor.constraint(equalToConstant: 66),
            
            // Currency Label
            currencyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            currencyLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            // Exchange Rate Label
            exchangeRateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            exchangeRateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            exchangeRateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: currencyLabel.trailingAnchor, constant: 16)
        ])
    }
    
    // MARK: - Public Methods
    
    func configure(currency: String, exchangeRate: String) {
        currencyLabel.text = currency
        exchangeRateLabel.text = exchangeRate
    }
}
