//
//  DateConverter.swift
//  Weather App
//
//  Created by mac on 16/09/2020.
//  Copyright © 2020 chavicodes. All rights reserved.
//

import UIKit
class DateConverter {
    func convertDate(_ date: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let currentDate = dateFormatter.date(from: date) else {return nil}
        let gregCalendar = Calendar(identifier: .gregorian)
        let weekDay = gregCalendar.component(.weekday, from: currentDate)
        let weekDays = ["", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        return weekDays[weekDay]
    }
}
