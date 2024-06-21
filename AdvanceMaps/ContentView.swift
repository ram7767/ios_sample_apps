//
//  ContentView.swift
//  AdvanceMaps
//
//  Created by Ram on 18/06/24.
//

import SwiftUI
import MapKit
import CoreLocation

struct ContentView: View {
    
    @ObservedObject var viewModel = ViewModel()
    @StateObject var monitor = Monitor()
    @StateObject var locationManager = LocationManager()
    
    @State private var search: String = ""
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005))
    @State private var cityname: String = ""
    @State private var tappedCoordinate: CLLocationCoordinate2D?
    
    func performSearch() {
        let group = DispatchGroup()
        
        group.enter()
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = search
        
        let searchLoc = MKLocalSearch(request: request)
        searchLoc.start { response, error in
            group.leave()
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let mapItem = response.mapItems.first {
                let coordinate = mapItem.placemark.coordinate
                self.region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                self.tappedCoordinate = coordinate
            }
        }
        
        group.enter()
        viewModel.refreshDetails(city: search) {
            search = ""
            group.leave()
        }
        
    }
    
    func tappedOnMap() {
        if let coordinates = self.tappedCoordinate {
            viewModel.refreshDetails(cordinates: ["lat": coordinates.latitude, "lon": coordinates.longitude], useCordinate: true)
        }
    }
    
    func centerOnUserLocation() {
        if let userLocation = locationManager.location {
            region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(#colorLiteral(red: 0.5809063911, green: 0.6992525458, blue: 0.9864879251, alpha: 0.4789453623))
                    .ignoresSafeArea()
                VStack {
                    SearchView(search: $search, onSearch: performSearch)
                    ZStack(alignment: .topLeading) {
                        CustomMapView(region: $region, tappedCoordinate: $tappedCoordinate, tappedOnMap: tappedOnMap)
                            .ignoresSafeArea()
                        WeatherReportView(city: viewModel.baseResponse.city?.name ?? "", icon: viewModel.baseResponse.list?[0].weather?[0].icon ?? "", temp: "\(viewModel.baseResponse.list?[0].main?.temp ?? 0)")
                        
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                ZStack {
                                    RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                                        .foregroundColor(.blue)
                                        .frame(width: 40, height: 40)
                                    Button(action: centerOnUserLocation) {
                                        Image(systemName: "location.circle.fill")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(.white)
                                    }
                                }
                                .padding()
                            }
                        }
                        .padding()
                    }
                    .ignoresSafeArea()
                }
            }
            .navigationTitle("Location")
            .onAppear {
                viewModel.refreshDetails()
                region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: self.viewModel.baseResponse.city?.coord?.lat ?? 0, longitude: self.viewModel.baseResponse.city?.coord?.lon ?? 0), span: MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005))
            }
        }
    }
}

#Preview {
    ContentView()
}
