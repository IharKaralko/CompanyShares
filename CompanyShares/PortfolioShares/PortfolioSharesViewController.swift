//
//  PortfolioSharesViewController.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/16/20.
//

import UIKit

protocol PortfolioSharesDisplayLogic: class {
    func displayShares(viewModel: PortfolioShares.ViewModel)
}

class PortfolioSharesViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private var shares = [ShareWithPrices]()
    private let heightTableViewRow: CGFloat = 140
    
    var portfolio: Portfolio!
    var interactor: PortfolioSharesBusinessLogic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PortfolioSharesConfigurator.shared.configure(with: self)
        navigationBarSetting()
        toolbarSetting()
        delegatesRegistration()
        tableCellRegistration()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isToolbarHidden = false
        interactor?.fetchShares(porfolio: portfolio)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
}

private extension PortfolioSharesViewController {
    func navigationBarSetting() {
        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.title = portfolio.name
        navigationItem.backButtonTitle = ""
    }
    
    func toolbarSetting() {
        var items = [UIBarButtonItem]()
        navigationController?.toolbar.tintColor = UIColor.black
        navigationController?.toolbar.barTintColor = #colorLiteral(red: 1, green: 0.7389495218, blue: 0.7303172605, alpha: 1)
        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) )
        items.append(UIBarButtonItem(title: "PortfolioShares_Add".localized, style: .plain, target: self, action: #selector(addShares)))
        self.toolbarItems = items
    }
    
    @objc
    func addShares() {
        let addShares = CompanyListViewController()
        addShares.isAddShares = true
        addShares.portfolio = portfolio
        navigationController?.pushViewController(addShares, animated: true)
    }
    
    
    func updateEditButtonState() {
        navigationItem.rightBarButtonItem?.isEnabled =  shares.count > 0
    }
    
    func delegatesRegistration() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableCellRegistration() {
        let identifier = String(describing: PortfolioSharesTableViewCell.self)
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
}

// MARK: - UITableViewDataSource
extension PortfolioSharesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shares.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: PortfolioSharesTableViewCell.self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? PortfolioSharesTableViewCell else {
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
extension PortfolioSharesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightTableViewRow
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "PortfolioShares_Delete".localized, handler: { [weak self] (_, _, _) in
            self?.deleteShare(at: indexPath)
        })
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - PortfolioSharesDisplayLogic
extension PortfolioSharesViewController: PortfolioSharesDisplayLogic {
    func displayShares(viewModel: PortfolioShares.ViewModel) {
        shares = viewModel.shares
        tableView.reloadData()
        updateEditButtonState()
    }
}
