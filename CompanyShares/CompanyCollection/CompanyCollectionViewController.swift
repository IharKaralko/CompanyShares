//
//  CompanyCollectionViewController.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/1/20.
//

import UIKit
import RealmSwift

protocol CompanyCollectionDisplayLogic: class {
    func displayCompany(viewModel: CompanyCollection.ViewModel)
    func reloadCompaniesList()
}

protocol ChildViewControllerProtocol: class {
    var routerDelegate: CompanyListRouterProtocol? { set get }
    func addCompany(company: Company)
}

class CompanyCollectionViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    private var companies: Results<Company>!
    private let sectionInsets = UIEdgeInsets(top:10.0, left: 10.0, bottom: 20.0, right: 10.0)
    private let itemsPerRow: CGFloat = 2
    
    var interactor: CompanyCollectionBusinessLogic?
    var routerDelegate: CompanyListRouterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CompanyCollectionConfigurator.shared.configure(with: self)
        interactor?.loadCompanyList()
        interactor?.setObserver()
        delegatesRegistration()
        collectionCellRegistration()
        longPressSetting()
    }
}

private extension CompanyCollectionViewController {
    func delegatesRegistration() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func collectionCellRegistration() {
        let identifier = String(describing: CompanyCollectionViewCell.self)
        let nib = UINib.init(nibName: identifier, bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    func longPressSetting() {
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
            let alertController = UIAlertController(title:"Attention!".localized, message: "Remove company?".localized, preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: "OK".localized, style: .default) {[weak self] action in
                guard let company = self?.companies[indexPath.row] else { return }
                self?.interactor?.removeCompany(company: company)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel)
            alertController.addAction(cancelAction)
            alertController.addAction(confirmAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            print("Could not find index path")
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CompanyCollectionViewController: UICollectionViewDelegateFlowLayout {
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
extension CompanyCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return companies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = String(describing: CompanyCollectionViewCell.self)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? CompanyCollectionViewCell else {
            fatalError("Cell with identifier: \(identifier) not found")
        }
        let copmany = companies[indexPath.row]
        cell.configure(copmany)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CompanyCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let company = companies[indexPath.row]
        routerDelegate?.routToDetails(company: company)
    }
}

// MARK: - ChildViewControllerProtocol
extension CompanyCollectionViewController: ChildViewControllerProtocol {
    func addCompany(company: Company) {
        interactor?.addCompany(company: company)
    }
}

// MARK: - CompanyCollectionDisplayLogic
extension CompanyCollectionViewController: CompanyCollectionDisplayLogic {
    func displayCompany(viewModel: CompanyCollection.ViewModel) {
        companies = viewModel.companies
        collectionView.reloadData()
    }
    
    func reloadCompaniesList() {
        collectionView.reloadData()
    }
}
