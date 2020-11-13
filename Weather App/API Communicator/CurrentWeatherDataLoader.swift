//
//  CurrentWeatherDataLoader.swift
//  Weather App
//
//  Created by mac on 14/09/2020.
//  Copyright © 2020 chavicodes. All rights reserved.
//

import UIKit
class CurrentWeatherDataLoader {
    var currentDelegate: CurrentWeatherProtocol?
    
    
    public func getData() {
        let session = URLSession.shared
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?id=2352947&units=metric&appid=6b0fa21ca2058f8d13416fcd591bdf78") else{ return }
        
        let task = session.dataTask(with: url, completionHandler: {  (data, response, error) in
            guard let data = data, error == nil else {
                print("error in parsing data")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("http error")
                    return
            }
            guard let mime = response?.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }
            var currentWeatherData: CurrentWeatherData?
            do {
                currentWeatherData = try JSONDecoder().decode(CurrentWeatherData.self, from: data)
            }
            catch {
                print("JSON error: \(error.localizedDescription)")
            }
            
            guard let json = currentWeatherData else {
                return
            }
            
            self.currentDelegate?.loadCurrentData(data: json)
            
        })
        task.resume()
        
    }
}
