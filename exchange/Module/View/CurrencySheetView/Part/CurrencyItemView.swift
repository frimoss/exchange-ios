//
//  CurrencyListView.swift
//  exchange
//
//  Created by Nikolai on 09/02/2026.
//

import UIKit

final class CurrencyItemView: UIView {
    
    // MARK: - UI Components
    
    // Flag Image
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "backgroundSecondary")
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ARS")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.text = "ARS"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor(named: "textPrimary")
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let checkbox: CircleCheckbox = {
        let checkbox = CircleCheckbox()
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        
        return checkbox
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupView() {
        addSubview(containerView)
        containerView.addSubview(imageView)
        addSubview(currencyLabel)
        addSubview(checkbox)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            // Height of Component
            heightAnchor.constraint(equalToConstant: 60),
            
            // Image Container
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 40),
            containerView.heightAnchor.constraint(equalToConstant: 40),
            
            // Flag Image
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 28),
            imageView.heightAnchor.constraint(equalToConstant: 28),
            
            // Currency Label
            currencyLabel.leadingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 8),
            currencyLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            currencyLabel.trailingAnchor.constraint(lessThanOrEqualTo: checkbox.leadingAnchor, constant: -8),
            
            // Checkbox
            checkbox.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            checkbox.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkbox.widthAnchor.constraint(equalToConstant: 24),
            checkbox.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    // MARK: - Configuration
    
    func configure(currency: String, isSelected: Bool) {
        currencyLabel.text = currency
        imageView.image = UIImage(named: currency)
    }
}
