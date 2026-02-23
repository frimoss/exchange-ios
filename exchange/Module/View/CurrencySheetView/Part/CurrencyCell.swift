//
//  CurrencyCell.swift
//  exchange
//
//  Created by Nikolai on 10/02/2026.
//

import UIKit

final class CurrencyCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "CurrencyCell"
    
    // MARK: - UI Components
    
    private let currencyItemView = CurrencyItemView()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupView() {
        contentView.addSubview(currencyItemView)
        currencyItemView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            currencyItemView.topAnchor.constraint(equalTo: contentView.topAnchor),
            currencyItemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            currencyItemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            currencyItemView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    // MARK: - Configuration
    
    func configure(currency: Currency, isSelected: Bool) {
        currencyItemView.configure(currency: currency, isSelected: isSelected)
    }
}
