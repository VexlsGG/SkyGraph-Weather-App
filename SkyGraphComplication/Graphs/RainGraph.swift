//
//  RainGraph.swift
//  SkyGraph
//
//  Created by Lisa Oliver on 6/17/25.
//


import SwiftUI

struct RainGraph: View {
    let rainValues: [Double]

    var body: some View {
        GeometryReader { geo in
            let height = geo.size.height
            let width = geo.size.width / CGFloat(rainValues.count)

            HStack(spacing: 2) {
                ForEach(rainValues.indices, id: \.self) { i in
                    let value = rainValues[i]
                    RoundedRectangle(cornerRadius: 2)
                        .fill(value > 0.6 ? .blue : .gray)
                        .frame(width: width, height: height * value)
                }
            }
        }
    }
}
