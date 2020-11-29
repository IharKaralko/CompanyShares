//
//  SelfSizedTableView.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 11/23/20.
//

import UIKit

class SelfSizedTableView: UITableView {
    var maxHeight: CGFloat?
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let height = min(contentSize.height, maxHeight ?? 0)
        self.layer.cornerRadius = height != maxHeight ? 25 : 0
        roundСorners(height)
        return CGSize(width: contentSize.width, height: height)
    }
}

extension SelfSizedTableView {
    func roundСorners(_ height: CGFloat) {
        self.layer.cornerRadius = height != maxHeight ? 25 : 0
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
}
