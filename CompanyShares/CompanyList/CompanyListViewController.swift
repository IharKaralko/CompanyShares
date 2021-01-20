//
// CompanyListViewController.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 11/18/20.
//

import UIKit

protocol CompanyListDisplayLogic: class {
    func displayPossibleOptions(viewModel: CompanyList.ViewModel)
}

protocol CompanyListRouterProtocol: class {
    func routToDetails(company: SelectedCompany)
    func popVC()
}

class CompanyListViewController: UIViewController {
    @IBOutlet private weak var tableView: SelfSizedTableView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private var possibleOptions = [Company]()
    private var childCollectionViewController: CompanyCollectionViewControllerProtocol?
    private var childAddSharesViewController: BuyAndSellSharesViewControllerProtocol?
    private let heightTableViewRow: CGFloat = 48
    
    var interactor: CompanyListBusinessLogic?
    var router: CompanyListRoutingLogic?
    var isAddShares: Bool?
    var portfolio: Portfolio?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CompanyListConfigurator.shared.configure(with: self)
        navigationBarSetting()
        delegatesRegistration()
        searchBarSetting()
        tableCellRegistration()
        setChild()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isToolbarHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
}

private extension CompanyListViewController {
    func addChildToConteiner(_ child: UIViewController) {
        child.willMove(toParent: self)
        addChild(child)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(child.view)
        
        NSLayoutConstraint.activate([
            child.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            child.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            child.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            child.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        child.didMove(toParent: self)
    }
 
    func setChild() {
        guard let isAddShares = isAddShares else { return }
        if isAddShares {
            let child = BuyAndSellSharesViewController()
            child.portfolio = portfolio
            child.isSellShare = false
            addChildToConteiner(child)
            child.routerDelegate = self
            childAddSharesViewController = child
        } else {
            let child = CompanyCollectionViewController()
            addChildToConteiner(child)
            child.routerDelegate = self
            childCollectionViewController = child
        }
    }

    @objc
    func adjustForKeyboard(notification: Notification) {
        if let userInfo = notification.userInfo, let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            tableView.maxHeight = view.frame.height - self.view.safeAreaInsets.top - searchBar.frame.height - keyboardRectangle.height
        }
    }
    
    func navigationBarSetting() {
        guard let isAddShares = isAddShares else { return }
        navigationItem.title = isAddShares ? "CompanyList_Add_Shares".localized : "CompanyList_Company_Shares".localized
        navigationController?.navigationBar.barTintColor = UIColor.red
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    func delegatesRegistration() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func searchBarSetting() {
        searchBar.delegate = self
        searchBar.tintColor = UIColor.black
        searchBar.barTintColor = UIColor.red
        searchBar.searchTextField.backgroundColor = .white
        searchBar.placeholder = "CompanyList_Input_ticker_or_name_company".localized
    }
    
    func tableCellRegistration() {
        let identifier = String(describing: CompanyListTableViewCell.self)
        let nib = UINib.init(nibName: identifier, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: identifier)
    }
    
    func finishSearch() {
        searchBar.text = ""
        possibleOptions = [Company]()
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
}

// MARK: - UISearchBarDelegate
extension CompanyListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            let request = CompanyList.Requst(keyword: searchText)
            interactor?.fetchPossibleOptions(request: request)
        } else {
            possibleOptions = [Company]()
            tableView.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        finishSearch()
    }
}

// MARK: - UITableViewDataSource
extension CompanyListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return possibleOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: CompanyListTableViewCell.self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? CompanyListTableViewCell else {
            fatalError("Cell with identifier: \(identifier) not found")
        }
        let company = possibleOptions[indexPath.row]
        cell.configure(company)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CompanyListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let company = possibleOptions[indexPath.row]
        guard let isAddShares = isAddShares else { return }
        if isAddShares {
            childAddSharesViewController?.addShares(company: company)
        } else {
            childCollectionViewController?.addCompany(company)
        }
        searchBar.showsCancelButton = false
        finishSearch()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightTableViewRow
    }
}

// MARK: - CompanyListDisplayLogic
extension CompanyListViewController: CompanyListDisplayLogic {
    func displayPossibleOptions(viewModel: CompanyList.ViewModel) {
        possibleOptions = viewModel.companies.sorted(by: { $0.symbol < $1.symbol })
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

// MARK: - CompanyListRouterProtocol
extension CompanyListViewController: CompanyListRouterProtocol {
    func routToDetails(company: SelectedCompany) {
        guard let navVC = navigationController else { return }
        router?.routeToCopmanyDetails(company: company, navVC: navVC)
    }
    
    func popVC() {
        navigationController?.popViewController(animated: true)
    }
}
