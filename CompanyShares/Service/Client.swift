//
//  Client.swift
//  CompanyShares
//
//  Created by Ihar_Karalko on 11/19/20.
//

import Foundation

class Client {
    static let apiKey = "c3856383367f49dbefe2a7b747cc57d0"
    
    enum Endpoints {
        static let base = "https://financialmodelingprep.com/api/v3/"
        static let apiKeyParam = "&apikey=\(Client.apiKey)"
        
        case searchCompany
        
        func getURL(keyword: String) -> URL? {
            switch self {
            case .searchCompany:
                let stringValue = Endpoints.base + "search?query=\(keyword)&limit=10" + Endpoints.apiKeyParam
                return URL(string: stringValue)
            }
        }
    }
    
    class func fetchCompanies(url: URL, completion: @escaping ([Company]?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request)
        { data, response, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode([Company].self, from: data)
                completion(responseObject, nil)
            } catch {
                print(error.localizedDescription)
                completion(nil, error)
            }
        }
        task.resume()
    }
}
