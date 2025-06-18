import AppIntents

enum CircularWidgetStyle: String, AppEnum {
    case tempRing
    case aqiRing
    case rainRing
    case thermoGauge
    case iconMini

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Widget Style"

    static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .tempRing: "Temp Ring 🔥",
        .aqiRing: "AQI Ring 🌫",
        .rainRing: "Rain Gauge 🌧",
        .thermoGauge: "Thermometer 🌡",
        .iconMini: "Minimal 🌤"
    ]
}
