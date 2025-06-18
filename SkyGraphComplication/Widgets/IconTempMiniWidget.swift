//
//  IconTempMiniWidget.swift
//  SkyGraph
//
//  Created by Lisa Oliver on 6/17/25.
//


import SwiftUI

struct IconTempMiniWidget: View {
    var temp: Int
    var icon: String

    var body: some View {
        VStack(spacing: -4) {
            Image(systemName: icon)
                .font(.system(size: 14))
            Text("\(temp)°")
                .font(.caption2.bold())
        }
    }
}
