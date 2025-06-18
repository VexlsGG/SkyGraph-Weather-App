//
//  CircularWidget.swift
//  SkyGraph
//
//  Created by Lisa Oliver on 6/17/25.
//


import SwiftUI

struct CircularWidget: View {
    var temp: Int
    var icon: String

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 4)
                .foregroundStyle(
                    AngularGradient(
                        gradient: Gradient(colors: [.blue, .mint, .cyan]),
                        center: .center
                    )
                )
            VStack(spacing: -2) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                Text("\(temp)°")
                    .font(.system(size: 13, weight: .bold))
            }
        }
    }
}
