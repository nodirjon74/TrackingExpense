//
//  Network.swift
//  TrackingExpenses
//
//  Created by Nodir on 27/12/22.
//

import Foundation

struct Network {
    
    func request(completion: @escaping (Result<Any, Error>) -> Void) {
        guard let url = URL(string: "https://api.coindesk.com/v1/bpi/currentprice.json") else {
            print("Error: cannot create URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling GET")
                print(error!)
                return
            }
            guard let safeData = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: safeData, options: [])
                let bpi = json as! [String: AnyObject]
                let usd = bpi["bpi"]!["USD"] as! [String: AnyObject]
                completion(.success(usd["rate_float"]!))
            } catch let jsonError {
                completion(.failure(jsonError.localizedDescription as! Error))
            }
        }.resume()
    }
}
