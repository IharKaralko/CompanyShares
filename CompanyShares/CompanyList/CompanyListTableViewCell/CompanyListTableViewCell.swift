//
//  CompanyListTableViewCell.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 11/18/20.
//

import UIKit

class CompanyListTableViewCell: UITableViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
}

extension CompanyListTableViewCell {
    func configure(_ company: Company) {
        nameLabel.text = company.symbol + " " + "(" + company.name + ")"
    }
}
