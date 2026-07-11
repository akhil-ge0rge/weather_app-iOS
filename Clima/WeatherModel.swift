//
//  WeatherModel.swift
//  Clima
//
//  Created by Akhil George on 11/07/26.
//  Copyright © 2026 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double

    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt.rain"

        case 300...321:
            return "cloud.drizzle"

        case 500...531:
            return "cloud.rain"

        case 600...622:
            return "snow"

        case 701...781:
            return "cloud.fog"

        case 800:
            return "sun.max"

        case 801:
            return "cloud.sun"

        case 802:
            return "cloud.sun"

        case 803...804:
            return "smoke"

        default:
            return "cloud"
        }
    }

}
