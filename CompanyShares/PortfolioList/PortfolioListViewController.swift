//
//  PortfolioListViewController.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/9/20.
//

import UIKit

protocol PortfolioListDisplayLogic: class {
    func displayPortfolioList(viewModel: PortfolioList.ViewModel)
}

class PortfolioListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private var portfolios = [PortfolioWithPrices]()
    private let heightTableViewRow: CGFloat = 90
    
    var interactor: PortfolioListBusinessLogic?
    var router: PortfolioListRoutingLogic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PortfolioListConfigurator.shared.configure(with: self)
        navigationBarSetting()
        delegatesRegistration()
        tableCellRegistration()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isToolbarHidden = true
        interactor?.fetchPortfolios()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
}

private extension PortfolioListViewController {
    func navigationBarSetting() {
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.title = "PortfolioList_Portfolios".localized
        navigationController?.navigationBar.barTintColor = UIColor.red
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "PortfolioList_Add".localized, style: .plain, target: self, action: #selector(addNewPortfolio))
    }
    
    @objc
    func addNewPortfolio() {
        alertForAddAndUpdatePortfolio()
    }
    
    func alertForAddAndUpdatePortfolio(_ portfolioWithPrices: PortfolioWithPrices? = nil) {
        var alertTextField = UITextField()
        var title = "PortfolioList_New_Portfolio".localized
        var doneButton = "PortfolioList_Save".localized
        
        if portfolioWithPrices != nil {
            title = "PortfolioList_Edit_Portfolio".localized
            doneButton = "PortfolioList_Update".localized
        }
        
        let alert = UIAlertController(title: title,  message: "PortfolioList_Enter_a_name_for_this_portfolio".localized, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "PortfolioList_Cancel".localized, style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: doneButton, style: .default) { [weak self] _ in
            guard let newName = alertTextField.text else { return }
            if let portfolioWithPrices = portfolioWithPrices {
                self?.update(portfolioWithPrices: portfolioWithPrices, name: newName)
            } else {
                self?.addPortfolio(name: newName)
            }
        }
        
        saveAction.isEnabled = false
        alert.addTextField { textField in
            alertTextField = textField
            if let portfolioWithPrices = portfolioWithPrices {
                alertTextField.text = portfolioWithPrices.portfolio.name
            }
            
            textField.placeholder = "PortfolioList_Name".localized
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: .main) { notif in
                if let text = textField.text, !(text.trimmingCharacters(in: .whitespacesAndNewlines)).isEmpty {
                    saveAction.isEnabled = true
                } else {
                    saveAction.isEnabled = false
                }
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        present(alert, animated: true, completion: nil)
    }
    
    func updateEditButtonState() {
        navigationItem.leftBarButtonItem?.isEnabled =  portfolios.count > 0
    }
    
    func delegatesRegistration() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableCellRegistration() {
        let identifier = String(describing: PortfolioListTableViewCell.self)
        let nib = UINib.init(nibName: identifier, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: identifier)
    }
    
    func deletePortfolio(at indexPath: IndexPath) {
        let portfolioToDelete = portfolios[indexPath.row]
        interactor?.remove(portfolio: portfolioToDelete.portfolio)
        portfolios.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        if portfolios.count == 0 {
            setEditing(false, animated: true)
        }
        updateEditButtonState()
    }
    
    func addPortfolio(name: String) {
        interactor?.addPortfolio(name: name)
    }
    
    func update(portfolioWithPrices: PortfolioWithPrices, name: String) {
        interactor?.update(portfolio: portfolioWithPrices.portfolio, name: name)
        portfolios = portfolios.sorted(by: { $0.portfolio.name ?? "" < $1.portfolio.name ?? ""})
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension PortfolioListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return portfolios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: PortfolioListTableViewCell.self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? PortfolioListTableViewCell else {
            fatalError("Cell with identifier: \(identifier) not found")
        }
        let portfolioWithPrices = portfolios[indexPath.row]
        cell.configure(portfolioWithPrices)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

// MARK: - UITableViewDelegate
extension PortfolioListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let portfolio = portfolios[indexPath.row].portfolio
        guard let navVC = navigationController else { return }
        router?.routeToPortfolioDetails(portfolio: portfolio, navVC: navVC)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightTableViewRow
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "PortfolioList_Delete".localized, handler: { [weak self] (_, _, _) in
            self?.deletePortfolio(at: indexPath)
        })
        
        let updateAction = UIContextualAction(style: .normal, title: "PortfolioList_Update".localized, handler: { [weak self] (_, _, _) in
            self?.alertForAddAndUpdatePortfolio(self?.portfolios[indexPath.row])
        })
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [updateAction, deleteAction])
    }
}

// MARK: - PortfolioListDisplayLogic
extension PortfolioListViewController: PortfolioListDisplayLogic {
    func displayPortfolioList(viewModel: PortfolioList.ViewModel) {
        portfolios = viewModel.portfoliosWithPrice.sorted(by: { $0.portfolio.name ?? "" < $1.portfolio.name ?? ""})
        tableView.reloadData()
        updateEditButtonState()
    }
}
