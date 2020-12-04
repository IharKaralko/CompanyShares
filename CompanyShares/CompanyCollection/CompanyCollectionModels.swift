//
//  CompanyCollectionModels.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/3/20.
//

import Foundation
import RealmSwift

enum CompanyCollection {
    struct Response {
        let companies: Results<Company>?
    }
    
    struct ViewModel {
        let companies: Results<Company>?
    }
}
