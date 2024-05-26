//
//  GyagData.swift
//  Clima
//
//  Created by 中佐徹也 on 2024/05/26.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

// Codable typealies: Protocal combined Decodable & Encodable
struct GyagData: Codable{
    // Value name must follow JSON property name
    let joke: String
    let id: Int
    let status: Int
}


