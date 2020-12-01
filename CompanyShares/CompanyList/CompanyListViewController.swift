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

class CompanyListViewController: UIViewController {
    @IBOutlet private weak var tableView: SelfSizedTableView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet private weak var searchBar: UISearchBar!
   
    private var possibleOptions = [Company]()
    private var companies = [Company]()
    
    private let sectionInsets = UIEdgeInsets(top:10.0, left: 10.0, bottom: 20.0, right: 10.0)
    private let itemsPerRow: CGFloat = 2
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
//        collectionCellRegistration()
//        longPressSetting()
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
        let controller = CompanyCollectionViewController()
        controller.didMove(toParent: self)
        addChild(controller)
            controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(controller.view)

            NSLayoutConstraint.activate([
                controller.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                controller.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                controller.view.topAnchor.constraint(equalTo: containerView.topAnchor),
                controller.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])

            controller.didMove(toParent: self)    }
    
    
    
    @objc
    func adjustForKeyboard(notification: Notification) {
        if let userInfo = notification.userInfo, let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            tableView.maxHeight = view.frame.height - self.view.safeAreaInsets.top - searchBar.frame.height - keyboardRectangle.height
        }
    }
    
    func navigationBarSetting() {
        self.navigationItem.title = NSLocalizedString("Company Share", comment: "")
        navigationController?.navigationBar.barTintColor = UIColor.red
    }
    
    func delegatesRegistration() {
        tableView.dataSource = self
        tableView.delegate = self
//        collectionView.dataSource = self
//        collectionView.delegate = self
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
    
//    func collectionCellRegistration() {
//        let identifier = String(describing: CompanyListCollectionViewCell.self)
//        let nib = UINib.init(nibName: identifier, bundle: nil)
//        self.collectionView.register(nib, forCellWithReuseIdentifier: identifier)
//    }
    
//    func longPressSetting(){
//        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(longPressGR:)))
//        longPressGR.minimumPressDuration = 0.5
//        longPressGR.delaysTouchesBegan = true
//        self.collectionView.addGestureRecognizer(longPressGR)
//    }
    
//    @objc
//    func handleLongPress(longPressGR: UILongPressGestureRecognizer) {
//        if longPressGR.state != .ended {
//            return
//        }
//
//        let point = longPressGR.location(in: self.collectionView)
//        let indexPath = self.collectionView.indexPathForItem(at: point)
//
//        if let indexPath = indexPath {
//            let alertController = UIAlertController(title: NSLocalizedString("Attention!", comment: ""),  message: NSLocalizedString("Remove company?", comment: ""), preferredStyle: .alert)
//
//            let confirmAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) {[weak self] action in
//                self?.companies.remove(at: indexPath.row)
//                self?.collectionView.reloadData()
//            }
//
//            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel)
//            alertController.addAction(cancelAction)
//            alertController.addAction(confirmAction)
//            self.present(alertController, animated: true, completion: nil)
//        } else {
//            print("Could not find index path")
//        }
//    }
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
        searchBar.text = ""
        possibleOptions = [Company]()
        tableView.reloadData()
        searchBar.resignFirstResponder()
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
        companies.append(company)
        companies = companies.sorted(by: { $0.symbol < $1.symbol })
     //   collectionView.reloadData()
        searchBar.text = ""
        possibleOptions = []
        tableView.reloadData()
        searchBar.resignFirstResponder()
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

// MARK: - UICollectionViewDelegateFlowLayout
extension CompanyListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let heighPerItem = 3 * widthPerItem  / 4
        
        return CGSize(width: widthPerItem, height: heighPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

// MARK: - UICollectionViewDataSource
extension CompanyListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return companies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = String(describing: CompanyListCollectionViewCell.self)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? CompanyListCollectionViewCell else {
            fatalError("Cell with identifier: \(identifier) not found")
        }
        let copmany = companies[indexPath.row]
        cell.configure(copmany)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CompanyListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let company = companies[indexPath.row]
        guard let navVC = navigationController else { return }
        router?.routeToCopmanyDetails(company: company, navVC: navVC)
    }
}
