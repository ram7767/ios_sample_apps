//
//  WeatherReportView.swift
//  AdvanceMaps
//
//  Created by Ram on 18/06/24.
//

import SwiftUI

struct WeatherReportView: View {
    var city: String
    var icon: String
    var temp: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                .frame(maxWidth: 100, maxHeight: 100)
                .padding()
                .foregroundColor(.white)
            VStack(spacing: 5) {
                Text(city)
                Image(systemName: icon.getIcon())
                    .font(.title2)
                    .foregroundColor(.blue)
                Text(temp)
                
            }
            
        }
        .frame(maxWidth: 500, maxHeight: 500, alignment: .topLeading)
    }
}

#Preview {
    WeatherReportView(city: "", icon: "", temp: "")
}
