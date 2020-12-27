//
//  CompanyPortfolioListTableViewCell.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/9/20.
//

import UIKit

class CompanyPortfolioListTableViewCell: UITableViewCell {
    @IBOutlet private weak var currentPriceLabel: UILabel!
    @IBOutlet private weak var symbolLabel: UILabel!
    @IBOutlet private weak var purchaseLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.borderWidth = 0.5
        
    }
}

extension CompanyPortfolioListTableViewCell {
    func configure(_ portfolio: PortfolioWithPrices) {
        symbolLabel.text = portfolio.portfolio.name
        purchaseLabel.text = portfolio.purchasePrice
        currentPriceLabel.attributedText = portfolio.priceAndChange
    }
}
