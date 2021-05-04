//
//  WeatherData.swift
//  Clima
//
//  Created by mohamed youssef on 5/3/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation

struct WeatherData: Codable { // Codable is type alias conform decocodable and encodable
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int //weather conditions
}
