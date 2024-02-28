//
//  ContentView.swift
//  weather_app
//
//  Created by Ram on 26/02/24.
//

import SwiftUI
import Network

struct ContentView: View {
    
    @State var search: String = ""
    @ObservedObject var viewModel = ViewModel()
    @StateObject var monitor = Monitor()
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [Color.blue.opacity(0.5), Color.white],startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        if monitor.status == NetworkStatus.disconnected {
                            VStack {
                                Text("Check the Network")
                                RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                                    .fill(.white)
                                    .opacity(0.50)
                                    .shadow(radius: 10.0)
                                    .frame(width: 100,height: 40)
                                    .overlay {
                                        Button {
                                            viewModel.refreshDetails()
                                        } label: {
                                            Text("Refresh")
                                                .foregroundStyle(.blue)
                                        }
                                    }
                            }
                        } else {
                            RoundedRectangle(cornerRadius: 25.0)
                                .fill(.white)
                                .opacity(0.50)
                                .shadow(radius: 10.0)
                                .frame(height: 50, alignment: .center)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                                .overlay {
                                    HStack {
                                        Image(systemName: "magnifyingglass.circle.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 25)
                                            .foregroundColor(.white)
                                            .padding()
                                        TextField("Enter Location", text: $search)
                                            .onSubmit() {
                                                viewModel.refreshDetails(city: search)
                                                search = ""
                                            }
                                    }
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                                }
                            
                            Text(viewModel.baseResponse.city?.name ?? "")
                                .font(.title)
                                .fontWeight(.semibold)
                                .padding()
                            
                            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                .frame(height: 150)
                                .foregroundColor(Color.blue)
                                .shadow(radius: 10, x: 5, y: 5)
                                .padding(.bottom, 10)
                                .overlay {
                                    
                                    VStack(spacing: 5) {
                                        Text("\(viewModel.baseResponse.list?[0].main?.temp ?? 0,  specifier: "%.2f")K")
                                            .font(.title)
                                            .foregroundColor(Color.white)
                                        
                                        
                                        Image(systemName: getIcon(icon: viewModel.baseResponse.list?[0].weather?[0].icon ?? ""))
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 35)
                                            .foregroundColor(.white)
                                            .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                                        
                                        Text(viewModel.baseResponse.list?[0].weather?[0].description ?? "")
                                            .font(.title2)
                                            .foregroundStyle(.white)
                                        
                                    }
                                }
                            
                            
                            VStack() {
                                Text("Wather forcast")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity ,alignment: .leading)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHStack {
                                        ForEach(0...25, id: \.self) { index in
                                            HourlyForecastCell(time: convertToAMPM(dateString: viewModel.baseResponse.list?[index + 1].dt_txt ?? ""), icon: getIcon(icon: viewModel.baseResponse.list?[index + 1].weather?[0].icon ?? ""), weather: viewModel.baseResponse.list?[index + 1].weather?[0].description ?? "")
                                        }
                                    }
                                }
                                .frame(height: 80)
                                
                            }
                            
                            Text("Additional Information")
                                .font(.title3)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity ,alignment: .leading)
                                .padding(.top, 10)
                            
                            HStack {
                                AdditionalInformationCell(icon: "humidity.fill", type: "Humidity", num: "\(viewModel.baseResponse.list?[0].main?.humidity ?? 0)")
                                AdditionalInformationCell(icon: "rectangle.compress.vertical", type: "Pressure", num: "\(viewModel.baseResponse.list?[0].main?.pressure ?? 0)")
                                AdditionalInformationCell(icon: "wind.snow", type: "Wind Speed", num: "\(viewModel.baseResponse.list?[0].wind?.speed ?? 0)")
                            }
                            .frame(height: 110)
                            
                            Spacer()
                        }
                    }
                    .safeAreaPadding()
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text("Weather App")
                                .foregroundStyle(.white)
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                viewModel.refreshDetails()
                            } label: {
                                Image(systemName: "arrow.circlepath")
                                    .font(.body)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text("")
                            }
                            
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarBackground(Color.blue, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                }
            }
            
        }
        .onAppear {
            viewModel.refreshDetails()
        }
    }
    
    func convertToAMPM(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = dateFormatter.date(from: dateString) else {
            return "Invalid Date"
        }
        
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: date)
    }
    
    func getIcon(icon: String) -> String {
        switch (icon) {
            
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

#Preview {
    ContentView()
}
