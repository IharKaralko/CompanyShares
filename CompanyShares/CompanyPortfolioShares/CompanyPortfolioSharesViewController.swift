//
//  CompanyPortfolioSharesViewController.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/16/20.
//

import UIKit

protocol CompanyPortfolioSharesDisplayLogic: class {
    func displayShares(viewModel: CompanyPortfolioShares.ViewModel)
}

class CompanyPortfolioSharesViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private var shares = [ShareWithPrices]()
    private let heightTableViewRow: CGFloat = 140
    
    var portfolio: Portfolio!
    var interactor: CompanyPortfolioSharesBusinessLogic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CompanyPortfolioSharesConfigurator.shared.configure(with: self)
        navigationBarSetting()
        toolbarSetting()
        delegatesRegistration()
        tableCellRegistration()
        interactor?.fetchShares(porfolio: portfolio)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
}

private extension CompanyPortfolioSharesViewController {
    func navigationBarSetting() {
        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.title = portfolio.name
        navigationController?.isToolbarHidden = false
    }
    
    func toolbarSetting() {
        var items = [UIBarButtonItem]()
        navigationController?.toolbar.tintColor = UIColor.black
        navigationController?.toolbar.barTintColor = #colorLiteral(red: 1, green: 0.7389495218, blue: 0.7303172605, alpha: 1)
        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) )
        items.append(UIBarButtonItem(title: "Add".localized, style: .plain, target: self, action: #selector(alertForAddShares)))
        self.toolbarItems = items
    }
    
    @objc
    func alertForAddShares() {
        var symbolTextField = UITextField()
        var countTextField = UITextField()
        var priceTextField = UITextField()
        
        let alert = UIAlertController(title: "New Shares".localized,  message: "Enter new shares details".localized, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title:"Save".localized, style: .default) { [weak self] _ in
            guard let portfolio = self?.portfolio else {return }
            guard let symbol = symbolTextField.text, let count = Int64(countTextField.text ?? ""), let price = Double(priceTextField.text ?? "") else { return }
            self?.addShare(symbol: symbol, count: count, price: price, portfolio: portfolio)}
        
        saveAction.isEnabled = false
        alert.addTextField { textField in
            symbolTextField = textField
            textField.placeholder = "Ticker".localized
        }
        alert.addTextField { textField in
            countTextField = textField
            textField.placeholder = "Amount".localized
        }
        
        alert.addTextField { textField in
            priceTextField = textField
            textField.placeholder = "Price".localized
        }
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: nil, queue: .main) {notif in
            if let text = symbolTextField.text, !(text.trimmingCharacters(in: .whitespaces)).isEmpty, UInt(countTextField.text ?? "") != nil,  let price = Double(priceTextField.text ?? ""), price >= 0 {
                saveAction.isEnabled = true
            } else {
                saveAction.isEnabled = false
            }
            
        }
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        present(alert, animated: true, completion: nil)
    }
    
    func updateEditButtonState() {
        navigationItem.rightBarButtonItem?.isEnabled =  shares.count > 0
    }
    
    func delegatesRegistration() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableCellRegistration() {
        let identifier = String(describing: CompanyPortfolioSharesTableViewCell.self)
        let nib = UINib.init(nibName: identifier, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: identifier)
    }
    
    func deleteShare(at indexPath: IndexPath) {
        interactor?.remove(share: shares[indexPath.row].share)
        shares.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        if shares.count == 0 {
            setEditing(false, animated: true)
        }
        updateEditButtonState()
    }
    
    func addShare(symbol: String, count: Int64, price: Double, portfolio: Portfolio) {
        interactor?.addShare(symbol: symbol, count: count, price: price, portfolio: portfolio)
    }
}

// MARK: - UITableViewDataSource
extension CompanyPortfolioSharesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shares.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: CompanyPortfolioSharesTableViewCell.self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? CompanyPortfolioSharesTableViewCell else {
            fatalError("Cell with identifier: \(identifier) not found")
        }
        let share = shares[indexPath.row]
        cell.configure(shareWithPrices: share)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

// MARK: - UITableViewDelegate
extension CompanyPortfolioSharesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightTableViewRow
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Delete", handler: { [weak self] (_, _, _) in
            self?.deleteShare(at: indexPath)
        })
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - CompanyPortfolioSharesDisplayLogic
extension CompanyPortfolioSharesViewController: CompanyPortfolioSharesDisplayLogic {
    func displayShares(viewModel: CompanyPortfolioShares.ViewModel) {
        shares = viewModel.shares
        tableView.reloadData()
        updateEditButtonState()
    }
}
