//
//  CurrentWeatherData.swift
//  Weather App
//
//  Created by mac on 14/09/2020.
//  Copyright © 2020 chavicodes. All rights reserved.
//

import UIKit
struct CurrentWeatherData: Codable {
    let main: CurrentWeatherTemperature
    let weather: [CurrentWeatherType]
}




