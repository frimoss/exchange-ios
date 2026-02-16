//
//  SwapButton.swift
//  exchange
//
//  Created by Nikolai on 06/02/2026.
//

import UIKit

final class SwapButton: UIButton {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    private func configure() {
        setImage(UIImage(systemName: "arrow.down.circle.fill"), for: .normal)
        tintColor = UIColor(named: "accentGreen")
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        
        // Icon Size
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        setPreferredSymbolConfiguration(config, forImageIn: .normal)
        
        // Haptic Feedback
        let feedback = UIImpactFeedbackGenerator(style: .medium)
        feedback.impactOccurred()
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Circle Radius
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
        clipsToBounds = true
        
        // Border
        layer.borderWidth = 6
        layer.borderColor = UIColor(named: "backgroundPrimary")?.cgColor
    }
}
