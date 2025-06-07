import Foundation

/// Wrapper for a deleted location with a timestamp
struct TrashedLocation: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var location: LocationDisplay
    /// Timestamp when the location was moved to trash
    var deletedAt: Date
    
    /// Returns true if item has been in trash for more than 30 days
    var isExpired: Bool {
        Date().timeIntervalSince(deletedAt) > 60 * 60 * 24 * 30
    }
}
