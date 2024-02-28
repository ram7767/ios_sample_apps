//
//  AdditionalInformationCell.swift
//  weather_app
//
//  Created by Ram on 27/02/24.
//

import Foundation
import SwiftUI

struct AdditionalInformationCell: View {
    
    var icon: String
    var type: String
    var num: String
    
    
    var body: some View {
        
        VStack {
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 15)
                .foregroundColor(.blue)
            
            Text(type)
                .foregroundColor(Color.black)
            
            Text(num)
                .foregroundStyle(.blue)
            
        }
        .frame(width: 100, height: 100)
    }
}
