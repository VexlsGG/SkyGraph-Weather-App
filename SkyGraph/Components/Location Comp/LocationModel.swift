import Foundation

struct LocationModel: Codable, Identifiable, Equatable {
    var id = UUID()
    let city: String
    let temp: Int
    let condition: String
    let weatherIconName: String
    let hourlyTemps: [Int]
}

