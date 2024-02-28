//
//  HourlyForecastCell.swift
//  weather_app
//
//  Created by Ram on 27/02/24.
//

import Foundation
import SwiftUI

struct HourlyForecastCell: View {
    
    var time: String
    var icon: String
    var weather: String
    
    
    var body: some View {
        
        RoundedRectangle(cornerSize: CGSize(width: 8, height: 8))
            .fill(.white)
            .opacity(0.50)
            .shadow(radius: 3.0,x: 2, y: 2)
            .frame(width: 80, height: 80)
            .overlay {
                VStack {
                    Text(time)
                        .font(.caption)
                        .foregroundColor(Color.black)
                    
                    
                    Image(systemName: icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 15)
                        .foregroundColor(.black)
                    
                    
                    Text(weather)
                        .font(.caption2)
                        .foregroundStyle(.black)
                    
                }
            }
        
    }
}
