//
//  WindPressureCard.swift
//  SkyGraph
//
//  Created by Lisa Oliver on 6/16/25.
//


import SwiftUI

struct WindPressureCard: View {
    var windSpeed: Double = 14.2
    var windDirection: String = "NW"
    var gusts: Double = 21.7
    var pressure: Double = 1013.6

    var body: some View {
        GlassyCard {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: "wind")
                    Text("Wind & Pressure")
                        .font(.headline)
                    Spacer()
                }

                HStack {
                    VStack(alignment: .leading) {
                        Text("Wind: \(Int(windSpeed)) mph \(windDirection)")
                        Text("Gusts: \(Int(gusts)) mph")
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("Pressure")
                        Text("\(Int(pressure)) hPa")
                    }
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary)
            }
        }
    }
}
