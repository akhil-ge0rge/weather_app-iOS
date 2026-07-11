//
//  WeatherManager.swift
//  Clima
//
//  Created by Akhil George on 10/07/26.
//  Copyright © 2026 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(
        _ weatherManager: WeatherManager,
        weather: WeatherModel
    )
    func didFailWithError(error: Error)
}

struct WeatherManager {

    var delegate: WeatherManagerDelegate?

    let weatherURL: String =
        "https://api.openweathermap.org/data/2.5/weather?appid=\(Secrets.openWeatherAPIKey)"

    func fetchWeather(cityName: String) {
        let url = "\(weatherURL)&q=\(cityName)&units=metric"
        print(url)
        performUrlRequest(with: url)
    }

    func performUrlRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(
                with: url,
                completionHandler: {
                    (data: Data?, response: URLResponse?, error: Error?) in
                    if error != nil {
                        self.delegate?.didFailWithError(error: error!)
                        return
                    }

                    if let safeData = data {
                        if let weather = self.parseJSON(safeData) {
                            self.delegate?.didUpdateWeather(
                                self,
                                weather: weather
                            )
                        }
                    }
                }
            )

            task.resume()
        }
    }

    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(
                WeatherData.self,
                from: weatherData
            )
            let id = decodedData.weather.first?.id ?? 0
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weatherModel = WeatherModel(
                conditionId: id,
                cityName: name,
                temperature: temp
            )
            return weatherModel
        } catch {
            delegate?.didFailWithError(error: error)
            return nil

        }

    }

}
