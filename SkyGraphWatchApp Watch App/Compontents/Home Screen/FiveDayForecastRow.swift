//
//  FiveDayForecastRow.swift
//  SkyGraph
//
//  Created by Lisa Oliver on 6/16/25.
//


import SwiftUI

struct FiveDayForecastRow: View {
    let day: DayForecast

    var body: some View {
        HStack {
            Text(day.day)
                .font(.system(size: 15, weight: .semibold))
                .frame(width: 34, alignment: .leading)
            Spacer()
            VStack(spacing: 0) {
                Image(systemName: day.icon)
                    .font(.system(size: 20))
                    .foregroundColor(.accentColor)
                if day.icon.contains("rain") || day.icon.contains("bolt") {
                    Text("\(Int(day.precip))%")
                        .font(.system(size: 9))
                        .foregroundColor(.blue)
                }
            }
            .frame(width: 36)
            Spacer()
            Text("\(Int(day.low))°")
                .font(.system(size: 13))
                .foregroundColor(.secondary)
            Text("/")
                .font(.system(size: 13))
                .foregroundColor(.secondary)
            Text("\(Int(day.high))°")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.primary)
        }
        .padding(.vertical, 1.5)
    }
}
