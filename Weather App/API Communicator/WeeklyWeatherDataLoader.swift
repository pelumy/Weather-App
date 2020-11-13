//
//  WeeklyWeatherDataLoader.swift
//  Weather App
//
//  Created by mac on 15/09/2020.
//  Copyright © 2020 chavicodes. All rights reserved.
//

import UIKit
class WeeklyWeatherDataLoader {
    var weeklyDelegate: WeeklyWeatherProtocol?
    
    public func getData() {
        let session = URLSession.shared
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?id=2352947&units=metric&appid=6b0fa21ca2058f8d13416fcd591bdf78") else{return}
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data, error == nil else {
                print("error in parsing weekly data")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("http error in weekly data")
                    return
            }
            guard let mime = response?.mimeType, mime == "application/json" else {
                print("Wrong MIME type of weekly data!")
                return
            }
            
            var weeklyWeatherData: WeeklyWeatherData?
            do {
                weeklyWeatherData = try JSONDecoder().decode(WeeklyWeatherData.self, from: data)
            }
            catch {
                print("JSON error: \(error)")
            }
            guard let json = weeklyWeatherData else {
                return
            }
            let arr = Array(arrayLiteral: json)
            let testing = arr[0].list.map {$0}.filter{$0.weekDay.contains("12:00:00")}
            //            print(testing)
            self.weeklyDelegate?.loadWeeklyData(data: testing)
        })
        task.resume()
    }
}
