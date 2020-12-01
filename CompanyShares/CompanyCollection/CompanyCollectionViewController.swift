//
//  CompanyCollectionViewController.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/1/20.
//

import UIKit

class CompanyCollectionViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    private var companies = [Company(symbol: "aa", name: "AAAA"),
                             Company(symbol: "aa", name: "AAAA"),
                             Company(symbol: "aa", name: "AAAA"),
    Company(symbol: "aa", name: "AAAA"),
        Company(symbol: "aa", name: "AAAA"),
        Company(symbol: "aa", name: "AAAA"),
                                 Company(symbol: "aa", name: "AAAA"),
                                 Company(symbol: "aa", name: "AAAA"),
        Company(symbol: "aa", name: "AAAA"),
            Company(symbol: "aa", name: "AAAA")    ]
    
    private let sectionInsets = UIEdgeInsets(top:10.0, left: 10.0, bottom: 20.0, right: 10.0)
    private let itemsPerRow: CGFloat = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            let alertController = UIAlertController(title: NSLocalizedString("Attention!", comment: ""),  message: NSLocalizedString("Remove company?", comment: ""), preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) {[weak self] action in
                self?.companies.remove(at: indexPath.row)
                self?.collectionView.reloadData()
            }
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel)
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
extension CompanyCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Select company")
      //  let company = companies[indexPath.row]
       // guard let navVC = navigationController else { return }
       // router?.routeToCopmanyDetails(company: company, navVC: navVC)
    }
}
