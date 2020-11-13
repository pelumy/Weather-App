//
//  CurrentWeatherTemperature.swift
//  Weather App
//
//  Created by mac on 14/09/2020.
//  Copyright © 2020 chavicodes. All rights reserved.
//

import UIKit
struct CurrentWeatherTemperature: Codable {
    let temp, tempMin, tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}
