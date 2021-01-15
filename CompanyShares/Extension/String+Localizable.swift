//
//  String+Localizable.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/23/20.
//

import Foundation

protocol Localizable {
    var localized: String { get }
}

extension String: Localizable {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
