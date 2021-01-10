//
//  PortfolioListTableViewCell.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/9/20.
//

import UIKit

class PortfolioListTableViewCell: UITableViewCell {
    @IBOutlet private weak var currentPriceLabel: UILabel!
    @IBOutlet private weak var symbolLabel: UILabel!
    @IBOutlet private weak var purchaseLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.borderWidth = 0.5
    }
}

extension PortfolioListTableViewCell {
    func configure(_ portfolioWithPrices: PortfolioWithPrices) {
        symbolLabel.text = portfolioWithPrices.portfolio.name
        purchaseLabel.text = portfolioWithPrices.purchasePrice
        currentPriceLabel.attributedText = portfolioWithPrices.priceAndChange
    }
}
