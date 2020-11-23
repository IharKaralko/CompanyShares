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
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var possibleOptions = [Company]()
    private var companies = [Company]()
    
    private let sectionInsets = UIEdgeInsets(top:10.0, left: 10.0, bottom: 20.0, right: 10.0)
    private let itemsPerRow: CGFloat = 2
    
    var interactor: CompanyListBusinessLogic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CompanyListConfigurator.shared.configure(with: self)
        navigationBarSetting()
        delegatesRegistration()
        searchControllerSetting()
        tableCellRegistration()
        collectionCellRegistration()
        longPressSetting()
    }
}

private extension CompanyListViewController {
    func navigationBarSetting() {
        self.navigationItem.title = "Company Share"
        navigationController?.navigationBar.barTintColor = UIColor.red
    }
    
    func delegatesRegistration() {
        tableView.dataSource = self
        tableView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func searchControllerSetting() {
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        searchController.obscuresBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barTintColor = UIColor.red
        searchController.searchBar.searchTextField.backgroundColor = .white
        searchController.searchBar.placeholder = "Input ticker or name company"
        searchController.hidesNavigationBarDuringPresentation = false
    }
    
    func tableCellRegistration() {
        let identifier = String(describing: CompanyListTableViewCell.self)
        let nib = UINib.init(nibName: identifier, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: identifier)
    }
    
    func collectionCellRegistration() {
        let identifier = String(describing: CompanyListCollectionViewCell.self)
        let nib = UINib.init(nibName: identifier, bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    func longPressSetting(){
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(longPressGR:)))
        longPressGR.minimumPressDuration = 0.5
        longPressGR.delaysTouchesBegan = true
        self.collectionView.addGestureRecognizer(longPressGR)
    }
    
    @objc
    func handleLongPress(longPressGR: UILongPressGestureRecognizer) {
        if longPressGR.state != .ended {
            return
        }
        
        let point = longPressGR.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: point)
        
        if let indexPath = indexPath {
            let alertController = UIAlertController(title: "Attention!", message: "Remove company?", preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: "OK", style: .default) {[weak self] action in
                self?.companies.remove(at: indexPath.row)
                self?.collectionView.reloadData()
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(cancelAction)
            alertController.addAction(confirmAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            print("Could not find index path")
        }
    }
}

// MARK: - UISearchResultsUpdating
extension CompanyListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let keyword = searchController.searchBar.text else { return }
        if keyword != "" {
            let request = CompanyList.Requst(keyword: keyword)
            interactor?.fetchPossibleOptions(request: request)
        } else {
            possibleOptions = [Company]()
            tableView.reloadData()
        }
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
        cell.configure(symbol: company.symbol, name: company.name)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CompanyListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let company = possibleOptions[indexPath.row]
        companies.append(company)
        collectionView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - CompanyListDisplayLogic
extension CompanyListViewController: CompanyListDisplayLogic {
    func displayPossibleOptions(viewModel: CompanyList.ViewModel) {
        possibleOptions = viewModel.companies
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
        cell.configure(symbol: copmany.symbol, name: copmany.name)
        return cell
    }
}
