//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import CoreLocation
import UIKit

class WeatherViewController: UIViewController {
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        weatherManager.delegate = self
        searchField.delegate = self

        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

    }

    @IBAction func locButtonPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}
//MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchField.endEditing(true)
        print(searchField.text ?? " NO DATA")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.endEditing(true)
        print(searchField.text ?? " NO DATA")
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchField.text?.isEmpty == false {
            return true
        } else {
            searchField.placeholder = "Enter a city"
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchField.text = ""
    }
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(
        _ weatherManager: WeatherManager,
        weather: WeatherModel
    ) {
        print(weather.temperature)
        DispatchQueue.main.async {
            self.temperatureLabel.text = String(weather.temperature)
            self.cityLabel.text = weather.cityName
            print(weather.conditionName)
            self.conditionImageView.image = UIImage(
                systemName: weather.conditionName
            )
        }
    }

    func didFailWithError(error: any Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let lastLoc = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = lastLoc.coordinate.latitude
            let long = lastLoc.coordinate.longitude

            weatherManager.fetchWeatherUsingLatLong(lat: lat, long: long)
        }
    }

    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: any Error
    ) {
        print(error)
    }
}
