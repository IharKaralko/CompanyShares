//
//  Client.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 11/19/20.
//

import Foundation

class Client {
    static let apiKey = "EQKMDVTR5WDOSTFU"
   
    enum Endpoints {
        static let baseFirst = "https://www.alphavantage.co/query?"
        static let apiKeyParam = "&apikey=\(Client.apiKey)"
        
        case searchCompany
        case getDetails
        
        func getURL(keyword: String) -> URL? {
            switch self {
            case .searchCompany:
                let stringValue = Endpoints.baseFirst + "function=SYMBOL_SEARCH&keywords=\(keyword)" + Endpoints.apiKeyParam
                return URL(string: stringValue)
            case .getDetails:
                let stringValue = Endpoints.baseFirst + "function=GLOBAL_QUOTE&symbol=\(keyword)" + Endpoints.apiKeyParam
                return URL(string: stringValue)
            }
        }
    }
    
    class func fetchCompanies(url: URL, completion: @escaping ([Company]?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(CompaniesResponse.self, from: data)
                completion(responseObject.bestMatches, nil)
            } catch {
                print(error.localizedDescription)
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    class func fetchDetails(url: URL, completion: @escaping (Details?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(DetailsResponse.self, from: data)
                completion(responseObject.globalQuote, nil)
            } catch {
                print(error.localizedDescription)
                completion(nil, error)
            }
        }
        task.resume()
    }
}
