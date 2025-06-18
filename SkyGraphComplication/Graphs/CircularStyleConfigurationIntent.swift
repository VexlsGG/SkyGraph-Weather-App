import AppIntents

struct CircularStyleConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Circular Style Configuration"
    static var description = IntentDescription("Select a style for your SkyGraph circular complication.")

    @Parameter(title: "Widget Style")
    var style: CircularWidgetStyle
}
