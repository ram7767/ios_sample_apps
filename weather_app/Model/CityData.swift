//
//  CityData.swift
//  weather_app
//
//  Created by Ram on 27/02/24.
//

import Foundation


struct BaseResponse: Codable {
    var cod: String?
    var message: Int?
    var cnt: Int = 0
    var list: [HourlyForecast]?
    var city: CityData?
}


struct CityData: Codable {
    var id: Int?
    var name: String?
    var country: String?
}

struct HourlyForecast: Codable {
    var main: MainData?
    var weather: [WeatherData]?
    var wind: WindData?
    var dt_txt: String?
}

struct MainData: Codable {
    var temp: Float?
    var humidity: Int?
    var pressure: Int?
}

struct WeatherData: Codable {
    var main: String?
    var description: String?
    var icon: String?
}

struct WindData: Codable {
    var speed: Float?
}
