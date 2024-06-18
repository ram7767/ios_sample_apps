//
//  String+Extension.swift
//  AdvanceMaps
//
//  Created by Ram on 18/06/24.
//

import Foundation

extension String {
    func getIcon() -> String {
        switch (self) {
            
        case "01d":
            return "sun.max.fill";
        case "01n":
            return "moon.zzz";
        case "02d":
            return "cloud";
        case "02n":
            return "cloud";
        case "03d":
            return "cloud.sun.fill";
        case "03n":
            return "cloud.moon.fill";
        case "04d":
            return "cloud.snow.fill";
        case "04n":
            return "cloud.snow.fill";
            
        case "09d":
            return "cloud.snow.fill";
        case "09n":
            return "cloud.snow.fill";
        case "11d":
            return "cloud.sun.bolt";
        case "11n":
            return "cloud.moon.bolt";
        case "13d":
            return "sun.snow.fill";
        case "13n":
            return "cloud.snow.fill";
        case "15d":
            return "cloud.fog";
        case "15n":
            return "cloud.fog";
        default:
            return "cloud.sun.rain.circle.fill";
        }
    }
}
