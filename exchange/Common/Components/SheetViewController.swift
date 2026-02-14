//
//  SheetViewController.swift
//  exchange
//
//  Created by Nikolai on 06/02/2026.
//

import UIKit

final class SheetViewController: UIViewController {
    
    // MARK: - UI Components
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "backgroundPrimary")
        view.layer.cornerRadius = 34
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        button.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
        button.tintColor = .secondaryLabel
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let contentContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: - Properties
    
    private let contentVC: UIViewController
    
    // MARK: - Init
    
    init(title: String, content: UIViewController) {
        self.contentVC = content
        super.init(nibName: nil, bundle: nil)
        self.titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSheet()
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Setup
    
    private func setupSheet() {
        if let sheet = sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 34
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .clear
        view.addSubview(containerView)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(closeButton)
        containerView.addSubview(contentContainer)
        
        // Add VC into Content Container
        addChild(contentVC)
        contentContainer.addSubview(contentVC.view)
        
        contentVC.view.frame = contentContainer.bounds
        contentVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentVC.didMove(toParent: self)
        
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Main Container
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Title Label
            titleLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -16),
            
            // Close Button
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            
            // Content Container
            contentContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            contentContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            contentContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            contentContainer.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    // MARK: - Button Action
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
}
