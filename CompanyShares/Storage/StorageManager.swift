//
//  StorageManager.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/3/20.
//

import UIKit
import RealmSwift

class StorageManager {
    static let realm = try? Realm()
}

extension StorageManager {
    static func saveCompany(_ company: Company) {
        DispatchQueue.main.async {
            do {
                try realm?.write {
                    realm?.add(company, update: .modified)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    static func removeCompany(_ company: Company) {
        DispatchQueue.main.async {
            do {
                try realm?.write {
                    realm?.delete(company)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
