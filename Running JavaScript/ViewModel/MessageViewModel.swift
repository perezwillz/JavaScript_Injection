//
//  MessageViewModel.swift
//  Running JavaScript
//
//  Created by Perez Willie Nwobu on 1/25/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import Foundation

class MessageViewModel {
    // Here I am using a singleton so there is one access to the MVM through out the app
    static let shared = MessageViewModel()
    // ID's represent the 4 progress bars that will be shown when the app is launched.
    let ids = [0, 1, 2, 3]
    let urlString =  "https://jumboassetsv1.blob.core.windows.net/publicfiles/interview_bundle.js"
}

// NetworkManagement
extension MessageViewModel {

     func getMessage(completion: @escaping (NetworkManager.Errors?, String) -> Void) {
        NetworkManager.fetchMessage { (data, error) in
            if let error = error {
                completion(.dataTaskError(error: error), "")
            }
            guard let data = data else {
                completion(.noDataReturned, "")
                return
            }
            guard let javaScript = String(data: data, encoding: .utf8) else { fatalError("Eror encoding data using .utf8") }
            completion(nil, javaScript)
        }
    }
    
}
