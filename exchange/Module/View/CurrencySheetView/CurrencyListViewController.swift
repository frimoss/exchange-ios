//
//  CurrencyListViewController.swift
//  exchange
//
//  Created by Nikolai on 10/02/2026.
//

import UIKit

final class CurrencyListViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let currencies: [Currency]
    private var selectedIndex: Int?
    private let selectionHandler: (Currency) -> Void
    
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
    
    init(currencies: [Currency], selectedCurrency: Currency, onSelect: @escaping (Currency) -> Void) {
        self.currencies = currencies
        self.selectedIndex = currencies.firstIndex(where: { $0.code == selectedCurrency.code })
        self.selectionHandler = onSelect
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
        view.backgroundColor = UIColor(named: "backgroundSecondary")
        view.layer.cornerRadius = 16
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
        
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CurrencyCell.identifier,
            for: indexPath
        ) as? CurrencyCell else {
            return UITableViewCell()
        }
        
        let currency = currencies[indexPath.row]
        
        let isSelected = selectedIndex == indexPath.row
        
        cell.configure(currency: currency, isSelected: isSelected)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard indexPath.row != selectedIndex else { return }
        
        // Check Selected Index
        let oldIndex = selectedIndex
        selectedIndex = indexPath.row
        
        // Reload Rows
        var indexPathsToReload = [indexPath]
        
        if let oldRow = oldIndex {
            indexPathsToReload.append(IndexPath(row: oldRow, section: 0))
        }

        tableView.reloadRows(at: indexPathsToReload, with: .none)
        
        // User Selection
        let selectedCurrency = currencies[indexPath.row]
        
        // Handle Selection
        selectionHandler(selectedCurrency)
        
        // Close Sheet
        dismiss(animated: true)
    }
}
