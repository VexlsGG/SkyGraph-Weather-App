import SwiftUI
import MapKit

struct RadarView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.3349, longitude: -122.00902),
                           span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5))
    )
    @State private var showLayers = false
    @State private var selectedLayers: Set<RadarLayer> = [.precipitation, .lightning]
    @State private var timelineValue: Double = 0.6
    @State private var isPlaying = false
    @State private var showLegend = false

    enum RadarLayer: String, CaseIterable, Identifiable, Hashable {
        case precipitation, lightning, wind, temperature, alerts, stormTrack
        var id: String { rawValue }
        var label: String {
            switch self {
            case .precipitation: return "Precipitation"
            case .lightning: return "Lightning"
            case .wind: return "Wind"
            case .temperature: return "Temperature"
            case .alerts: return "Alerts"
            case .stormTrack: return "Storm Track"
            }
        }
        var icon: String {
            switch self {
            case .precipitation: return "cloud.rain.fill"
            case .lightning: return "bolt.fill"
            case .wind: return "wind"
            case .temperature: return "thermometer.sun"
            case .alerts: return "bell.badge"
            case .stormTrack: return "arrow.triangle.turn.up.right.diamond.fill"
            }
        }
        var color: Color {
            switch self {
            case .precipitation: return .blue
            case .lightning: return .yellow
            case .wind: return .teal
            case .temperature: return .orange
            case .alerts: return .red
            case .stormTrack: return .purple
            }
        }
    }

    var body: some View {
        ZStack {
            Map(position: $position)
                .overlay(
                    Group {
                        if selectedLayers.contains(.precipitation) {
                            Image("radar_sample")
                                .resizable()
                                .scaledToFill()
                                .opacity(0.6)
                                .blendMode(.plusLighter)
                        }
                        if selectedLayers.contains(.lightning) {
                            LightningAnimatedOverlay()
                        }
                        if selectedLayers.contains(.stormTrack) {
                            StormTrackAnimatedOverlay()
                        }
                        if selectedLayers.contains(.wind) {
                            WindFlowAnimatedOverlay()
                        }
                    }
                )
                .ignoresSafeArea()
                .blur(radius: showLayers || showLegend ? 6 : 0)
                .overlay(AnimatedGlassParticles())
                .animation(.easeInOut, value: selectedLayers)

            VStack {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.secondary)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .shadow(radius: 6)
                            .padding(4)
                    }
                    Spacer()
                }
                .padding(.top, 18)
                .padding(.horizontal, 14)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .top)

            VStack {
                Spacer()
                VStack {
                    Slider(value: $timelineValue, in: 0...1)
                        .accentColor(.blue)
                        .padding(.horizontal, 28)
                        .padding(.top, 8)
                    HStack {
                        Text("Past")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Button(action: { isPlaying.toggle() }) {
                            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                .font(.title3.bold())
                                .padding(6)
                                .background(.thinMaterial)
                                .clipShape(Circle())
                        }
                        Spacer()
                        Text("Future")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 36)
                    .padding(.bottom, 8)
                }
                .background(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .shadow(radius: 8)
                )
                .padding(.horizontal, 16)

                HStack(spacing: 20) {
                    QuickActionButton(icon: "slider.horizontal.3", title: "Layers") {
                        withAnimation { showLayers.toggle() }
                    }
                    QuickActionButton(icon: "map.legend", title: "Legend") {
                        withAnimation { showLegend.toggle() }
                    }
                }
                .padding(.top, 6)
                .padding(.bottom, 22)
            }
            .frame(maxWidth: .infinity)
            .ignoresSafeArea(edges: .bottom)

            if showLayers {
                RadarLayerPicker(selectedLayers: $selectedLayers)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(101)
                    .onTapGesture { showLayers = false }
            }

            if showLegend {
                RadarLegendView()
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                    .zIndex(101)
                    .onTapGesture { showLegend = false }
            }
        }
        .background(Color("Background").ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
    }
}

struct QuickActionButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                Image(systemName: icon)
                    .font(.title3)
                Text(title)
                    .font(.caption2)
            }
            .padding(9)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
    }
}

struct RadarLayerPicker: View {
    @Binding var selectedLayers: Set<RadarView.RadarLayer>
    var body: some View {
        VStack(spacing: 14) {
            Capsule().frame(width: 36, height: 5).foregroundColor(.gray.opacity(0.26))
            Text("Radar Layers")
                .font(.headline.bold())
                .padding(.top, 2)
            ForEach(RadarView.RadarLayer.allCases) { layer in
                Button(action: {
                    if selectedLayers.contains(layer) {
                        selectedLayers.remove(layer)
                    } else {
                        selectedLayers.insert(layer)
                    }
                }) {
                    HStack {
                        Image(systemName: layer.icon)
                            .foregroundColor(layer.color)
                        Text(layer.label)
                            .font(.body)
                        Spacer()
                        if selectedLayers.contains(layer) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 8)
                }
            }
            Spacer()
        }
        .padding(.top, 8)
        .padding(.bottom, 22)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(radius: 8)
        .padding(.horizontal, 22)
    }
}

struct RadarLegendView: View {
    var body: some View {
        VStack(alignment: .trailing, spacing: 10) {
            Text("Radar Legend")
                .font(.headline)
                .padding(.bottom, 8)
            HStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(.blue)
                    .frame(width: 30, height: 16)
                Text("Light Rain")
                    .font(.caption)
            }
            HStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(.purple)
                    .frame(width: 30, height: 16)
                Text("Heavy Rain")
                    .font(.caption)
            }
            HStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(.yellow)
                    .frame(width: 30, height: 16)
                Text("Lightning")
                    .font(.caption)
            }
            Spacer()
        }
        .padding(.top, 44)
        .padding(.trailing, 20)
        .frame(maxWidth: 220, alignment: .trailing)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(radius: 8)
    }
}


struct LightningAnimatedOverlay: View {
    @State private var flash = false
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<3, id: \.self) { _ in
                    if flash {
                        Image(systemName: "bolt.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.yellow.opacity(0.7))
                            .position(
                                x: .random(in: 0...geo.size.width),
                                y: .random(in: 0...geo.size.height)
                            )
                            .blur(radius: 1)
                            .transition(.opacity)
                    }
                }
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 0.13).repeatForever(autoreverses: true)) {
                    flash.toggle()
                }
            }
        }
    }
}

struct StormTrackAnimatedOverlay: View {
    @State private var animate = false
    var body: some View {
        GeometryReader { geo in
            ForEach(0..<2, id: \.self) { i in
                Path { path in
                    let start = CGPoint(x: geo.size.width * 0.3, y: geo.size.height * (0.5 + 0.2 * Double(i)))
                    let end = CGPoint(x: geo.size.width * 0.8, y: geo.size.height * (0.5 + 0.15 * Double(i)))
                    path.move(to: start)
                    path.addQuadCurve(to: end, control: CGPoint(x: geo.size.width * 0.55, y: geo.size.height * (0.3 + 0.35 * Double(i))))
                }
                .stroke(
                    LinearGradient(colors: [.purple.opacity(0.5), .clear], startPoint: .leading, endPoint: .trailing),
                    style: StrokeStyle(lineWidth: 6, dash: [animate ? 12 : 3, 12], dashPhase: animate ? 0 : 18)
                )
                .animation(.linear(duration: 2.2).repeatForever(autoreverses: false), value: animate)
                .onAppear { animate.toggle() }
            }
        }
    }
}

struct WindFlowAnimatedOverlay: View {
    @State private var move = false
    var body: some View {
        GeometryReader { geo in
            ForEach(0..<7, id: \.self) { i in
                Path { path in
                    let y = geo.size.height * (0.13 + 0.11 * Double(i))
                    path.move(to: CGPoint(x: move ? -40 : geo.size.width + 40, y: y))
                    path.addLine(to: CGPoint(x: move ? geo.size.width + 40 : -40, y: y + .random(in: -7...7)))
                }
                .stroke(Color.teal.opacity(0.19), style: StrokeStyle(lineWidth: 3, dash: [8, 16], dashPhase: move ? 24 : 0))
                .animation(.easeInOut(duration: 7).repeatForever(autoreverses: true), value: move)
                .onAppear { move.toggle() }
            }
        }
    }
}

struct AnimatedGlassParticles: View {
    @State private var animate = false
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial.opacity(0.15))
                    .frame(width: 80, height: 80)
                    .offset(x: animate ? 80 : -40, y: animate ? 40 : 0)
                    .blur(radius: 12)
                Circle()
                    .fill(.ultraThinMaterial.opacity(0.10))
                    .frame(width: 44, height: 44)
                    .offset(x: animate ? -40 : 60, y: animate ? -60 : 60)
                    .blur(radius: 10)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                    animate.toggle()
                }
            }
        }
        .allowsHitTesting(false)
        .ignoresSafeArea()
    }
}

#Preview {
    RadarView()
}
