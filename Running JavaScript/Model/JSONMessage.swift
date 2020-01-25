//
//  JSONMessage.swift
//  Running JavaScript
//
//  Created by Perez Willie Nwobu on 1/25/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import Foundation
// JSONMessage represents the data that we will be decoding from the javascript file
struct JSONMessage: Decodable {
    var id: String?
    var message: String?
    var progress: Int?
    var state: String?
}
