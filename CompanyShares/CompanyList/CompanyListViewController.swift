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
    func routToDetails(company: Company)
}

class CompanyListViewController: UIViewController {
    @IBOutlet private weak var tableView: SelfSizedTableView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private var possibleOptions = [Company]()
    private var childViewController: ChildViewControllerProtocol?
    private let heightTableViewRow: CGFloat = 48
    
    var interactor: CompanyListBusinessLogic?
    var router: CompanyListRoutingLogic?
    
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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustForKeyboard),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
}

private extension CompanyListViewController {
    func setChild() {
        let child = CompanyCollectionViewController()
        child.routerDelegate = self
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
        childViewController = child
    }
    
    @objc
    func adjustForKeyboard(notification: Notification) {
        if let userInfo = notification.userInfo, let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            tableView.maxHeight = view.frame.height - self.view.safeAreaInsets.top - searchBar.frame.height - keyboardRectangle.height
        }
    }
    
    func navigationBarSetting() {
        navigationItem.title = NSLocalizedString("Company Share", comment: "")
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
        searchBar.tintColor = UIColor.white
        searchBar.barTintColor = UIColor.red
        searchBar.searchTextField.backgroundColor = .white
        searchBar.placeholder = NSLocalizedString("Input ticker or name company", comment: "")
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
        childViewController?.addCompany(company: company)
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
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
}

// MARK: - CompanyListRouterProtocol
extension CompanyListViewController: CompanyListRouterProtocol {
    func routToDetails(company: Company) {
        guard let navVC = navigationController else { return }
        router?.routeToCopmanyDetails(company: company, navVC: navVC)
    }
}
