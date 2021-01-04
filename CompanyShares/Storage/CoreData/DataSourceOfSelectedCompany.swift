//
//  DataSourceOfSelectedCompany.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 12/28/20.
//

import Foundation
import CoreData

protocol DataSourceOfSelectedCompanyProtocol: class {
    func getSelectedCompanies()  -> [SelectedCompany]
    func create(company: Company)
    func remove(selectedCompany: SelectedCompany)
}

class DataSourceOfSelectedCompany {
    private  var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataManager.instance.persistentContainer.viewContext) {
        self.context = context
    }
}

// MARK: - DataSourceOfSelectedCompanyProtocol
extension DataSourceOfSelectedCompany: DataSourceOfSelectedCompanyProtocol {
    func getSelectedCompanies() -> [SelectedCompany] {
        var companies = [SelectedCompany]()
        let fetchRequest = createFetchRequest()
        if let result = try? context.fetch(fetchRequest) {
            companies = result
        }
        return companies
    }
    
    func create(company: Company) {
        let fetchRequest = createFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "symbol == %@", company.symbol)
        guard let result = try? context.fetch(fetchRequest) else { return }
        if result.count == 0 {
            let selectedCompany = SelectedCompany(context: context)
            selectedCompany.symbol = company.symbol
            selectedCompany.name = company.name
            CoreDataManager.instance.saveContext()
        }
    }
    
    func remove(selectedCompany: SelectedCompany) {
        context.delete(selectedCompany)
        CoreDataManager.instance.saveContext()
    }
}

private extension DataSourceOfSelectedCompany {
    func createFetchRequest() -> NSFetchRequest<SelectedCompany> {
        let fetchRequest: NSFetchRequest<SelectedCompany> = SelectedCompany.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "symbol", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
}
