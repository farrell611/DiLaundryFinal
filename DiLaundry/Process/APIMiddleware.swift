//
//  APIMiddleware.swift
//  DiLaundry
//
//  Created by Theodorus Farrell on 1/21/23.
//

import Foundation

class APIMiddleware {
    let baseURL: String
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func send<T: Codable>(object: T, to endpoint: String) {
        let url = URL(string: baseURL + endpoint)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(object)
//            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
//            print(jsonObject)
            
            request.httpBody = jsonData
            URLSession.shared.dataTask(with: request) { data, response, error in
                // handle response here
//                print(data ?? "no data")
//                print(response ?? "no reponse")
//                print(error ?? "no error")
            }.resume()
            
        } catch {
            debugPrint("Error encoding object: \(error)")
        }

        

    }
}
