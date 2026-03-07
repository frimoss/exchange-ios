//
//  CurrencyListViewController.swift
//  exchange
//
//  Created by Nikolai on 10/02/2026.
//

import UIKit

final class CurrencyListViewController: UIViewController {
    
    // MARK: - Dependencies
    
    private let viewModel: CurrencyListViewModel
    
    // MARK: - UI Components
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CurrencyCell.self, forCellReuseIdentifier: CurrencyCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    // MARK: - Init
    
    init(viewModel: CurrencyListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = AppStyle.Color.backgroundSecondary
        view.layer.cornerRadius = AppStyle.Metrics.cornerRadius
        view.clipsToBounds = true
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 4),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableView Delegate & DataSource -

extension CurrencyListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.numberOfCurrencies
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get Cell
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CurrencyCell.identifier,
            for: indexPath
        ) as? CurrencyCell else {
            return UITableViewCell()
        }
        
        let currency = viewModel.currency(at: indexPath.row)
        let isSelected = viewModel.isSelected(at: indexPath.row)
        
        // Configure Cell
        cell.configure(currency: currency, isSelected: isSelected)
        
        // Handle Tap on CheckBox
        cell.onToggle = { [weak self] in
            guard let self, let actualPath = tableView.indexPath(for: cell) else { return }
            
            self.handleSelection(at: actualPath)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        handleSelection(at: indexPath)
    }
    
    // MARK: - Selection
    
    private func handleSelection(at indexPath: IndexPath) {
        
        // Update Selected Currency
        viewModel.selectCurrency(at: indexPath.row)
        
        // Update Table View
        tableView.reloadData()
        
        // Close sheet
        if viewModel.shouldDismiss {
            dismiss(animated: true)
        }
    }
}
