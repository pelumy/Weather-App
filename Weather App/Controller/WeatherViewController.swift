//
//  WeatherViewController.swift
//  Weather App
//
//  Created by mac on 13/09/2020.
//  Copyright © 2020 chavicodes. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    var currentWeatherData: CurrentWeatherData?
    var weeklyWeatherData: [WeeklyWeatherDataArray]?
    
    @IBOutlet weak var minimumTemperatureLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var maximumTemperatureLabel: UILabel!
    @IBOutlet weak var topCurrentTemperatureLabel: UILabel!
    @IBOutlet weak var currentWeatherTypeLabel: UILabel!
    @IBOutlet weak var topBackgroundImage: UIImageView!
    @IBOutlet weak var bottomDisplay: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.retrieveCurrentData()
        self.currentData()
        let theCurrent = CurrentWeatherDataLoader()
        theCurrent.currentDelegate = self
        theCurrent.getData()
        
        self.retrieveWeeklyData()
        let theWeekly = WeeklyWeatherDataLoader()
        theWeekly.weeklyDelegate = self
        theWeekly.getData()
    }
    
    func saveCurrentData() {
        if let encoded = try? JSONEncoder().encode(self.currentWeatherData) {
            UserDefaults.standard.set(encoded, forKey: "currentData")
        }
    }
    
    func retrieveCurrentData() {
        DispatchQueue.main.async {
            if let current = UserDefaults.standard.data(forKey: "currentData"),
                let currentData = try? JSONDecoder().decode(CurrentWeatherData.self, from: current) {
                self.currentWeatherData = currentData
            }
        }
    }
    
    func saveWeeklyData(_ forecastedData: [WeeklyWeatherDataArray]) {
        DispatchQueue.main.async {
            if let encoded = try? JSONEncoder().encode(forecastedData) {
                UserDefaults.standard.set(encoded, forKey: "weeklyData")
            }
        }
    }
    
    func retrieveWeeklyData() {
        if let weekly = UserDefaults.standard.data(forKey: "weeklyData"),
            let weeklyData = try? JSONDecoder().decode([WeeklyWeatherDataArray].self, from: weekly) {
            self.weeklyWeatherData = weeklyData
        }
        self.bottomDisplay.reloadData()
    }
    
    func currentData() {
        DispatchQueue.main.async {
            let accessProperty = String(self.currentWeatherData?.weather[0].main ?? "" )
            
            if accessProperty == "Clouds" || accessProperty == "Atmosphere" {
                self.topBackgroundImage.image = UIImage(named: "sea_cloudy")
                self.currentWeatherTypeLabel.text = (String((self.currentWeatherData?.weather[0].main ?? "").dropLast() ) + "y").uppercased()
                self.view.backgroundColor = UIColor(red: 84/255.0, green: 113/255.0, blue: 122/255.0, alpha: 1.0)
            }
            else if accessProperty == "Rain" || accessProperty == "Thunderstorm" || accessProperty == "Drizzle" {
                self.topBackgroundImage.image = UIImage(named: "sea_rainy")
                self.currentWeatherTypeLabel.text = (String((self.currentWeatherData?.weather[0].main ?? "")) + "y").uppercased()
                self.view.backgroundColor = UIColor(red: 87/255.0, green: 87/255.0, blue: 93/255.0, alpha: 1.0)
            }
            else if accessProperty == "Clear" {
                self.topBackgroundImage.image = UIImage(named: "sea_sunny")
                self.currentWeatherTypeLabel.text = "Sunny".uppercased()
                self.view.backgroundColor = #colorLiteral(red: 0.2916044295, green: 0.5656878948, blue: 0.8853569627, alpha: 1)  
            }
            
            self.minimumTemperatureLabel.text = "\(Int(self.currentWeatherData?.main.tempMin ?? 0))" + " °"
            self.currentTemperatureLabel.text = "\(Int(self.currentWeatherData?.main.temp ?? 0))" + " °"
            self.topCurrentTemperatureLabel.text = "\(Int(self.currentWeatherData?.main.temp ?? 0))"
            self.maximumTemperatureLabel.text = "\(Int(self.currentWeatherData?.main.tempMax ?? 0))" + " °"
            
        }
    }
}

extension WeatherViewController: CurrentWeatherProtocol, WeeklyWeatherProtocol {
    
    func loadCurrentData(data: CurrentWeatherData) {
        self.currentWeatherData = data
        self.saveCurrentData()
        self.currentData()
    }
    
    func loadWeeklyData(data: [WeeklyWeatherDataArray]) {
        DispatchQueue.main.async {
            self.weeklyWeatherData = data
            self.saveWeeklyData(data)
            self.bottomDisplay.reloadData()
        }
    }
    
}

extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeklyWeatherData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? WeatherTableViewCell {
            let filteredData = weeklyWeatherData?[indexPath.row]
            cell.temperatureLabel.text = "\(Int(filteredData?.main.temp ?? 0.0))" + " °"
            cell.weekdayLabel.text = DateConverter().convertDate(String(Array(filteredData?.weekDay ?? "")[0 ... 9]))
            
            let weatherType = filteredData?.weather[0].main
            if  weatherType == "Rain" || weatherType == "Thunderstorm" || weatherType == "Drizzle"  {
                cell.weatherImageLabel.image = UIImage(named: "rain")
            }
            else if weatherType == "Clouds" || weatherType == "Atmosphere"  {
                cell.weatherImageLabel.image = UIImage(named: "partlysunny")
            }
            else if weatherType == "Clear" {
                cell.weatherImageLabel.image = UIImage(named: "clear")
            }
            return cell
        }
        return UITableViewCell()
    }
}
