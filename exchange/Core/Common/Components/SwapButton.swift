//
//  SwapButton.swift
//  exchange
//
//  Created by Nikolai on 06/02/2026.
//

import UIKit

final class SwapButton: UIButton {
    
    // MARK: - UI Components
    
    private let symbolConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
    
    private lazy var swapIcon: UIImage? = {
        return UIImage(systemName: "arrow.down.circle.fill")?
            .withConfiguration(symbolConfig)
    }()
    
    // MARK: - Button Background Colors
    
    private let activeColor = AppStyle.Color.backgroundSecondary
    private let loadingColor = AppStyle.Color.backgroundPrimary
    
    // MARK: - Loader
    
    private lazy var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .medium)
        loader.hidesWhenStopped = true
        loader.color = AppStyle.Color.textPrimary
        loader.isUserInteractionEnabled = false
        loader.translatesAutoresizingMaskIntoConstraints = false
        
        return loader
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setupLoader()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    private func configure() {
        tintColor = AppStyle.Color.accent
        backgroundColor = activeColor
        translatesAutoresizingMaskIntoConstraints = false
        
        // Set Swap Icon
        setImage(swapIcon, for: .normal)
    }
    
    private func setupLoader() {
        addSubview(loader)
        
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Circle Radius
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
        
        // Border
        layer.borderWidth = 6
        layer.borderColor = AppStyle.Color.backgroundPrimary.cgColor
    }
    
    // MARK: - Public Methods
    
    func setLoading(_ isLoading: Bool) {
        
        // Disable Button when Loading
        isEnabled = !isLoading
        
        backgroundColor = isLoading ? loadingColor : activeColor
        
        // Show Loader OR Swap Icon
        if isLoading {
            setImage(nil, for: .normal) // Hide Swap Icon
            loader.startAnimating()
        } else {
            setImage(swapIcon, for: .normal) // Set Swap Icon
            loader.stopAnimating()
        }
    }
}
