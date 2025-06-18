//
//  TempRingWidget.swift
//  SkyGraph
//
//  Created by Lisa Oliver on 6/17/25.
//


import SwiftUI

struct TempRingWidget: View {
    var temp: Int
    var icon: String

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 5)
                .foregroundStyle(AngularGradient(
                    gradient: Gradient(colors: [.blue, .cyan, .mint]),
                    center: .center
                ))
            VStack(spacing: -2) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                Text("\(temp)°")
                    .font(.system(size: 12, weight: .bold))
            }
        }
    }
}
