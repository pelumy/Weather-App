//
//  WeeklyWeatherDataArray.swift
//  Weather App
//
//  Created by mac on 15/09/2020.
//  Copyright © 2020 chavicodes. All rights reserved.
//

import UIKit
struct  WeeklyWeatherDataArray: Codable {
    let main: WeeklyWeatherDataTemperature
    let weather: [WeeklyWeatherType]
    let weekDay: String
    
    enum CodingKeys: String, CodingKey {
        case main, weather
        case weekDay = "dt_txt"
    }
}
