//
//  WeatherMoodQuoteCard.swift
//  SkyGraph
//
//  Created by Lisa Oliver on 6/16/25.
//


import SwiftUI

struct WeatherMoodQuoteCard: View {
    let quotes = [
        "Clear skies, clear mind.",
        "Let the wind carry your worries away.",
        "A little rain never hurt anyone.",
        "Sunshine is the best medicine.",
        "Even cloudy days have silver linings."
    ]

    var body: some View {
        GlassyCard {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: "quote.bubble.fill")
                    Text("Weather Mood")
                        .font(.headline)
                    Spacer()
                }

                Text(quotes.randomElement() ?? "")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primary)
                    .italic()
            }
        }
    }
}
