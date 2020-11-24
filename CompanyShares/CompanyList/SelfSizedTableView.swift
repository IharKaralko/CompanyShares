//
//  SelfSizedTableView.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 11/23/20.
//

import UIKit

class SelfSizedTableView: UITableView {
  private var maxHeight: CGFloat = 300
    
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
  override var intrinsicContentSize: CGSize {
    let height = min(contentSize.height, maxHeight)
    return CGSize(width: contentSize.width, height: height)
  }
}
