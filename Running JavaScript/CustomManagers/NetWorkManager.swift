//
//  NetWorkManager.swift
//  Running JavaScript
//
//  Created by Perez Willie Nwobu on 1/25/20.
//  Copyright © Perez Willie Nwobu. All rights reserved.
//

import Foundation
import UIKit

class NetworkManager{
    
    private enum Method: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    
    enum Errors: Error {
        case constructingURLFailed
        case noDataReturned
        case decodingDataFailed
        case badURL
        case dataTaskError(error: Error)
    }
    
    private static func makeRequest(method: NetworkManager.Method = .get, baseURLString: String, appendingPaths: [String] = [], queries: [String: String] = [:], headers: [String: String] = [:], encodedData: Data? = nil, completion: @escaping (Data?, NetworkManager.Errors?) -> Void) {
        // Configures url path
        var url = URL(string: baseURLString)
        for path in appendingPaths {
            url?.appendPathComponent(path)
        }
        // Configures queries
        var queryArray = [URLQueryItem]()
        for query in queries {
            queryArray.append(URLQueryItem(name: query.key, value: query.value))
        }
        // Configures entire url
        var urlComponents = URLComponents()
        urlComponents.scheme = url?.scheme
        urlComponents.host = url?.host
        urlComponents.path = url?.path ?? ""
        if queryArray.count > 0 {
            urlComponents.queryItems = queryArray
        }
        
        // Unwraps url
        guard let finalURL = urlComponents.url else {
            NSLog("Constructing the URL has failed")
            completion(nil, .constructingURLFailed)
            return
        }
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        // Adds headers
        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        // Adds body data
        request.httpBody = encodedData
        
        
        // Creates data task
        dataTask(request: request, completion: completion)
    }
    
    private static func dataTask(request: URLRequest, completion: @escaping (Data?, NetworkManager.Errors?) -> Void) {
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    NSLog("An error occurred during network request: \(error)")
                    completion(nil, .dataTaskError(error: error))
                }
                completion(data, nil)
            }
            }.resume()
    }
    
    static func fetchMessage(completion: @escaping (Data?, NetworkManager.Errors?) -> Void) {
        makeRequest(method: .get, baseURLString: MessageViewModel.shared.urlString, completion: completion)
    }

}
