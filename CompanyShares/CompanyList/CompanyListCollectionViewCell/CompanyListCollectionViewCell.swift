//
//  CompanyListCollectionViewCell.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 11/21/20.
//

import UIKit

class CompanyListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var symbolLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var conteinerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        conteinerView.layer.cornerRadius = 10
    }
}
extension CompanyListCollectionViewCell {
    func configure(_ company: Company) {
        symbolLabel.text = company.symbol
        nameLabel.text = company.name
    }
}
