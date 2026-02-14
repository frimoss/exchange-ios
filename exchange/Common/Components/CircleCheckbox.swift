//
//  CircleCheckbox.swift
//  exchange
//
//  Created by Nikolai on 10/02/2026.
//

import UIKit

final class CircleCheckbox: UIControl {
    
    // MARK: - Properties
    
    var isChecked: Bool = false {
        didSet {
            updateAppearance()
        }
    }
    
    // MARK: - UI Components
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 24),
            heightAnchor.constraint(equalToConstant: 24),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        addTarget(self, action: #selector(toggle), for: .touchUpInside)
        updateAppearance()
    }
    
    private func updateAppearance() {
        let imageName = isChecked ? "checkmark.circle.fill" : "circle"
        imageView.image = UIImage(systemName: imageName)
        imageView.tintColor = isChecked ? .systemGreen : .systemGray3
    }
    
    // MARK: - Button Action
    
    @objc private func toggle() {
        isChecked.toggle()
        sendActions(for: .valueChanged)
    }
}
