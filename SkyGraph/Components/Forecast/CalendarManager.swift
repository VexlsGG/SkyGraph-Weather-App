import EventKit

class CalendarManager {
    static let shared = CalendarManager()
    private let eventStore = EKEventStore()

    func requestAccess(completion: @escaping (Bool) -> Void) {
        eventStore.requestAccess(to: .event) { granted, _ in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    func addWeatherEvent(for day: ForecastDayModel, completion: @escaping (Bool, Error?) -> Void) {
        requestAccess { granted in
            guard granted else {
                completion(false, nil)
                return
            }
            let event = EKEvent(eventStore: self.eventStore)
            event.title = "Weather: \(day.summary)"
            event.startDate = day.date
            event.endDate = Calendar.current.date(byAdding: .hour, value: 1, to: day.date) ?? day.date
            event.notes = "High: \(Int(day.high))°, Low: \(Int(day.low))°, Chance of Rain: \(Int(day.precipChance * 100))%"
            event.calendar = self.eventStore.defaultCalendarForNewEvents
            do {
                try self.eventStore.save(event, span: .thisEvent)
                completion(true, nil)
            } catch {
                completion(false, error)
            }
        }
    }
}
