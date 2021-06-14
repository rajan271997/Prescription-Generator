//
//  WebServiceHelper.swift
//  Prescription Generator
//
//  Created by Rajan Arora on 12/06/21.
//

import Foundation

enum WebServiceMethods {
    case GET_MEDICINES
}


class WebServiceHelper {
    
    private init() {} // Singleton Pattern
    
    static var instance = WebServiceHelper() // Single Instance
    
    private let baseURL = "https://6082d0095dbd2c001757a8de.mockapi.io/api/"
    
    func performRequest(type : WebServiceMethods,completionHandler : @escaping ((Result<Any,Error>) -> Void)) {
        switch type {
        case .GET_MEDICINES:
            fetchingData(type: type, completionHandler: completionHandler)
        }
    }
    
    
    private func fetchingData(type : WebServiceMethods,completionHandler : @escaping ((Result<Any,Error>) -> Void)) {
        var urlString : String?
        
        switch type {
        case .GET_MEDICINES:
            urlString = baseURL + "medicines"
        }
        
        guard let url = URL(string: urlString!) else {
            print("Failed to make url")
            return
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, response, error) in
            if (error != nil)  {
                print(error?.localizedDescription ?? "")
                completionHandler(.failure(error!))
                return
            }
            
            completionHandler(.success(data!))
            
        }.resume()
    }
    
}
