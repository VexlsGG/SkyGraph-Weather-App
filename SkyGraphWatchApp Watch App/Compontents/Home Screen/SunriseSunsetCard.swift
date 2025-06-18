//
//  SunriseSunsetCard.swift
//  SkyGraph
//
//  Created by Lisa Oliver on 6/16/25.
//


import SwiftUI

struct SunriseSunsetCard: View {
    var sunriseTime: String = "6:14 AM"
    var sunsetTime: String = "8:09 PM"

    var body: some View {
        GlassyCard {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: "sunrise.fill")
                    Text("Sunrise & Sunset")
                        .font(.headline)
                    Spacer()
                }

                HStack(spacing: 16) {
                    HStack(spacing: 6) {
                        Image(systemName: "sunrise")
                            .foregroundColor(.orange)
                        Text(sunriseTime)
                    }
                    HStack(spacing: 6) {
                        Image(systemName: "sunset")
                            .foregroundColor(.pink)
                        Text(sunsetTime)
                    }
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary)
            }
        }
    }
}
