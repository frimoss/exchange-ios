//
//  CircleCheckbox.swift
//  exchange
//
//  Created by Nikolai on 10/02/2026.
//

import UIKit

final class CircleCheckbox: UIControl {
    
    // MARK: - Properties
    
    var onToggle: (() -> Void)?
    
    var isChecked: Bool = false {
        didSet {
            guard oldValue != isChecked else { return }
            updateAppearance()
        }
    }
    
    // MARK: - UI Components
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setup() {
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24),
            
            // Component Size
            widthAnchor.constraint(equalToConstant: 24),
            heightAnchor.constraint(equalToConstant: 24)
        ])
        
        // Handle Toggle
        addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        updateAppearance()
    }
    
    private func updateAppearance() {
        let imageName = isChecked ? "checkmark.circle.fill" : "circle"
        imageView.image = UIImage(systemName: imageName)
        imageView.tintColor = isChecked ? .systemGreen : .systemGray2
    }
    
    // MARK: - Button Action
    
    @objc private func handleTap() {
        onToggle?()
    }
}
