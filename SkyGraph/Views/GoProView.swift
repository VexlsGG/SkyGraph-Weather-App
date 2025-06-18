import SwiftUI

struct GoProView: View {
    @Binding var isProUser: Bool
    @State private var selectedPlan: Int = 0
    @State private var isPresentingSubscribe = false
    @State private var showConfetti = false
    @Namespace private var proNamespace

    let proFeatures: [ProFeature] = [
        .init(icon: "network", color: .cyan, title: "Change Provider", subtitle: "Switch weather sources anytime."),
        .init(icon: "app.gift.fill", color: .purple, title: "Custom App Icons", subtitle: "Personalize your SkyGraph icon."),
        .init(icon: "square.grid.2x2.fill", color: .indigo, title: "All Widgets", subtitle: "Unlock every home/lock widget."),
        .init(icon: "person.2.badge.gearshape.fill", color: .orange, title: "Feature Requests", subtitle: "Vote & suggest features."),
        .init(icon: "hand.raised.fill", color: .pink, title: "Priority Support", subtitle: "Skip the line for help."),
        .init(icon: "sparkles", color: .mint, title: "More to Come", subtitle: "Get every future feature first.")
    ]

    var body: some View {
        ZStack {
            AnimatedBlobBackground()
                .ignoresSafeArea()
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    heroHeader
                    planToggle
                    featureCarousel
                    featureGrid
                    testimonial
                    subscribeButton
                }
            }
            if showConfetti {
                ConfettiView()
                    .transition(.opacity.combined(with: .scale))
            }
        }
    }

    var heroHeader: some View {
        ZStack {
            HStack {
                Spacer()
                ProRibbon()
                    .matchedGeometryEffect(id: "proribbon", in: proNamespace)
                    .offset(y: 34)
            }
            VStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 38)
                        .fill(.ultraThinMaterial)
                        .frame(width: 120, height: 120)
                        .shadow(color: Color("Graph Line 1").opacity(0.18), radius: 24, y: 6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 38)
                                .stroke(
                                    LinearGradient(colors: [Color("Graph Line 1"), Color("Graph Line 2")], startPoint: .top, endPoint: .bottom),
                                    lineWidth: 2.2
                                )
                        )
                    Image("Logo")
                        .resizable()
                        .frame(width: 76, height: 76)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                }
                .padding(.bottom, 4)
                HStack(spacing: 12) {
                    Text("SkyGraph")
                        .font(.system(size: 36, weight: .heavy, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(colors: [Color("Graph Line 1"), Color("Graph Line 2")], startPoint: .leading, endPoint: .trailing)
                        )
                    Text("PRO")
                        .font(.system(size: 36, weight: .heavy, design: .rounded))
                        .foregroundStyle(.white)
                        .shadow(color: Color("Graph Line 2"), radius: 6, y: 1)
                        .background(
                            Capsule()
                                .fill(LinearGradient(colors: [Color("Graph Line 1"), Color("Graph Line 2")], startPoint: .top, endPoint: .bottom))
                                .shadow(color: Color("Graph Line 1").opacity(0.19), radius: 10, y: 2)
                                .frame(height: 36)
                        )
                        .offset(y: -1)
                }
                .padding(.top, 1)
                Text("Weather. Unlocked.")
                    .font(.title3.weight(.medium))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.top, 24)
        .padding(.bottom, 10)
    }

    var planToggle: some View {
        PlanToggle(selectedPlan: $selectedPlan)
            .padding(.top, 16)
            .padding(.bottom, 6)
    }

    var featureCarousel: some View {
        FeatureCarousel(features: proFeatures, namespace: proNamespace)
            .padding(.top, 12)
            .padding(.bottom, 2)
    }

    var featureGrid: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Everything Pro Includes:")
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.leading, 7)
                .padding(.top, 18)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 19) {
                ForEach(proFeatures) { feature in
                    ProFeatureGridItem(feature: feature)
                }
            }
            .padding(.horizontal, 6)
        }
        .padding(.bottom, 20)
    }

    var testimonial: some View {
        HStack {
            Image(systemName: "quote.opening")
                .font(.title2)
                .foregroundColor(Color("Graph Line 1"))
            Text("“SkyGraph Pro is the best weather upgrade I’ve ever bought.”")
                .font(.callout.italic())
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding(.bottom, 18)
        .padding(.horizontal, 16)
    }

    var subscribeButton: some View {
        VStack(spacing: 9) {
            Button(action: {
                withAnimation { showConfetti = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                    showConfetti = false
                }
                isPresentingSubscribe = true
            }) {
                HStack {
                    Image(systemName: "crown.fill")
                        .foregroundColor(.yellow)
                        .font(.title3.bold())
                    Text(selectedPlan == 0 ? "Go Pro for $2.99/month" : "Go Pro for $24.99/year")
                        .font(.title2.bold())
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    RoundedRectangle(cornerRadius: 22)
                        .fill(
                            LinearGradient(
                                colors: [Color("Graph Line 1"), Color("Graph Line 2")],
                                startPoint: .leading, endPoint: .trailing
                            )
                        )
                        .shadow(color: Color("Graph Line 2").opacity(0.19), radius: 15, y: 4)
                )
                .foregroundColor(.white)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 2)
            Text("Cancel anytime. Family sharing included.")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.bottom, 10)
        }
        .sheet(isPresented: $isPresentingSubscribe) {
            SubscribeSheet(isProUser: $isProUser)
        }
    }
}

struct ProFeature: Identifiable {
    let id = UUID()
    let icon: String
    let color: Color
    let title: String
    let subtitle: String
}

struct PlanToggle: View {
    @Binding var selectedPlan: Int
    private let plans = [
        (icon: "calendar", text: "Monthly"),
        (icon: "calendar.badge.clock", text: "Annual")
    ]
    var body: some View {
        HStack(spacing: 0) {
            planButton(idx: 0)
            planButton(idx: 1)
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 18).fill(.ultraThinMaterial)
        )
        .padding(.horizontal, 36)
        .shadow(color: Color("Graph Line 2").opacity(0.06), radius: 4, y: 1)
    }

    @ViewBuilder
    private func planButton(idx: Int) -> some View {
        let isSelected = selectedPlan == idx
        Button(action: {
            withAnimation { selectedPlan = idx }
        }) {
            HStack(spacing: 4) {
                Image(systemName: plans[idx].icon)
                    .foregroundColor(isSelected ? .white : .secondary)
                Text(plans[idx].text)
                    .fontWeight(isSelected ? .bold : .regular)
                    .foregroundColor(isSelected ? .white : .secondary)
            }
            .padding(.vertical, 9)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        isSelected
                            ? AnyShapeStyle(LinearGradient(colors: [Color("Graph Line 1"), Color("Graph Line 2")], startPoint: .topLeading, endPoint: .bottomTrailing))
                            : AnyShapeStyle(Color.clear)
                    )
                    .shadow(color: isSelected ? Color("Graph Line 1").opacity(0.15) : .clear, radius: 6, y: 2)
            )
        }
    }
}

struct FeatureCarousel: View {
    let features: [ProFeature]
    var namespace: Namespace.ID
    @State private var selection: Int = 0
    var body: some View {
        TabView(selection: $selection) {
            ForEach(features.indices, id: \.self) { idx in
                VStack(spacing: 6) {
                    ZStack {
                        Circle()
                            .fill(features[idx].color.opacity(0.22))
                            .frame(width: 78, height: 78)
                            .shadow(color: features[idx].color.opacity(0.12), radius: 14, y: 6)
                        Image(systemName: features[idx].icon)
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(features[idx].color)
                            .scaleEffect(selection == idx ? 1.18 : 1.0)
                            .animation(.spring(), value: selection)
                    }
                    .padding(.bottom, 2)
                    Text(features[idx].title)
                        .font(.title3.bold())
                        .foregroundStyle(
                            LinearGradient(colors: [features[idx].color, Color("Graph Line 1")], startPoint: .leading, endPoint: .trailing)
                        )
                    Text(features[idx].subtitle)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 260)
                }
                .padding(.top, 8)
                .padding(.bottom, 12)
                .tag(idx)
            }
        }
        .frame(height: 148)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .background(.ultraThinMaterial)
        .cornerRadius(28)
        .padding(.horizontal, 32)
        .shadow(color: Color("Graph Line 2").opacity(0.08), radius: 12, y: 3)
    }
}

struct ProFeatureGridItem: View {
    let feature: ProFeature
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [feature.color, feature.color.opacity(0.20)], startPoint: .top, endPoint: .bottom))
                    .frame(width: 40, height: 40)
                Image(systemName: feature.icon)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }
            Text(feature.title)
                .font(.subheadline.weight(.bold))
                .multilineTextAlignment(.center)
            Text(feature.subtitle)
                .font(.caption2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(6)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .cornerRadius(14)
        .shadow(color: feature.color.opacity(0.08), radius: 6, y: 2)
    }
}

struct AnimatedBlobBackground: View {
    @State private var anim = false
    var body: some View {
        ZStack {
            Color("Background")
            ForEach(0..<3) { i in
                Ellipse()
                    .fill(LinearGradient(colors: [
                        i == 0 ? Color("Graph Line 1") : (i == 1 ? Color("Graph Line 2") : .purple),
                        .clear
                    ], startPoint: .top, endPoint: .bottom))
                    .frame(width: 400, height: 320)
                    .offset(x: CGFloat(i-1) * 120, y: CGFloat(i-1) * 90 + (anim ? 20 : -20))
                    .opacity(0.24 - Double(i)*0.07)
                    .blur(radius: 44)
                    .animation(.easeInOut(duration: 7.5).repeatForever(autoreverses: true), value: anim)
            }
        }
        .onAppear { anim = true }
    }
}

struct ConfettiView: View {
    @State private var isAnimating = false
    let colors: [Color] = [.yellow, .cyan, .purple, .mint, .orange, .pink, .indigo]
    var body: some View {
        GeometryReader { geo in
            ForEach(0..<28) { i in
                Circle()
                    .fill(colors[i % colors.count])
                    .frame(width: 8 + CGFloat(i%3)*2)
                    .position(
                        x: CGFloat.random(in: 0...geo.size.width),
                        y: isAnimating ? geo.size.height + 20 : CGFloat.random(in: 0...60)
                    )
                    .opacity(0.8)
                    .animation(
                        .easeOut(duration: Double.random(in: 1.6...2.2)),
                        value: isAnimating
                    )
            }
        }
        .onAppear { isAnimating = true }
        .ignoresSafeArea()
    }
}

struct ProRibbon: View {
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
            Text("PRO")
                .font(.headline.bold())
                .foregroundColor(.white)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(LinearGradient(colors: [Color.yellow, Color("Graph Line 1"), Color("Graph Line 2")], startPoint: .leading, endPoint: .trailing))
                .shadow(color: Color.yellow.opacity(0.25), radius: 7, y: 2)
        )
        .rotationEffect(.degrees(14))
        .offset(x: 0, y: -8)
    }
}

struct SubscribeSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var isProUser: Bool

    var body: some View {
        VStack(spacing: 24) {
            Text("Subscribe to SkyGraph Pro")
                .font(.title.bold())
            Text("All Pro features, priority support, and new updates for one price.")
                .font(.callout)
                .multilineTextAlignment(.center)
            Button("Subscribe Now") {
                isProUser = true
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            Button("Not Now", role: .cancel) { dismiss() }
        }
        .padding()
    }
}
