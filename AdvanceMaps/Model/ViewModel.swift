//
//  ViewModel.swift
//  AdvanceMaps
//
//  Created by Ram on 18/06/24.
//

import Foundation
import SwiftUI
import Network



final class ViewModel: ObservableObject {
    
    @Published var baseResponse: BaseResponse = BaseResponse()
    @Published var isInternetReachable: Bool = false
    
    func refreshDetails(city: String = "nandyal", cordinates: [String: Double] = [:], useCordinate: Bool = false, completion: (() -> Void)? = nil) {
        var baseURL = "https://api.openweathermap.org/data/2.5/forecast?"
        let appid = "&appid=24628d9e32ac156d9c1b9f02661cd1b0"
        
        if useCordinate, let lat = cordinates["lat"], let lon = cordinates["lon"] {
            baseURL += "lat=\(lat)&lon=\(lon)"
        } else {
            baseURL += "q=\(city)"
        }
        guard let url = URL(string: baseURL + appid) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let decodedResponse = try? JSONDecoder().decode(BaseResponse.self, from: data) {
                DispatchQueue.main.async {
                    print(decodedResponse)
                    self.baseResponse = decodedResponse
                    self.isInternetReachable = true
                }
            } else {
                print("Failed to decode JSON")
            }
        }.resume()
    }
}


enum NetworkStatus: String {
    case connected
    case disconnected
}

class Monitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")

    @Published var status: NetworkStatus = .connected

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }

            // Monitor runs on a background thread so we need to publish
            // on the main thread
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    print("We're connected!")
                    self.status = .connected

                } else {
                    print("No connection.")
                    self.status = .disconnected
                }
            }
        }
        monitor.start(queue: queue)
    }
}
