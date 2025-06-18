//
//  TwoDayTempGraphCard.swift
//  SkyGraph
//
//  Created by Lisa Oliver on 6/16/25.
//


import SwiftUI

struct TwoDayTempGraphCard: View {
    let days: [(String, Double, Double)] = [
        ("Today", 72, 58),
        ("Tomorrow", 76, 61)
    ]

    var body: some View {
        GlassyCard {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("2-Day Temp Trend")
                        .font(.headline)
                    Spacer()
                }

                HStack(spacing: 12) {
                    ForEach(days, id: \.0) { day, high, low in
                        VStack(spacing: 4) {
                            Text(day)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            ZStack {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(
                                        LinearGradient(
                                            colors: [.blue, .red],
                                            startPoint: .bottom, endPoint: .top)
                                    )
                                    .frame(width: 6, height: CGFloat(high - low) * 1.8)
                                VStack(spacing: 1) {
                                    Text("\(Int(high))°").font(.caption2)
                                    Text("\(Int(low))°").font(.caption2).foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
                .padding(.top, 6)
            }
        }
    }
}
