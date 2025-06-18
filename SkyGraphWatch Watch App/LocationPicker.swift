import SwiftUI

struct LocationPicker: View {
    let locations: [String]
    @Binding var selectedIndex: Int
    let dismiss: () -> Void

    var body: some View {
        VStack(spacing: 14) {
            Text("Choose Location")
                .font(.headline)
                .padding(.top, 6)
            List {
                ForEach(locations.indices, id: \.self) { idx in
                    HStack {
                        Text(locations[idx])
                            .font(.body)
                        Spacer()
                        if idx == selectedIndex {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.accentColor)
                                .font(.system(size: 18))
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedIndex = idx
                        WKInterfaceDevice.current().play(.success)
                        dismiss()
                    }
                }
            }
            .listStyle(.carousel)
            .frame(height: 120)
            Button("Done", action: dismiss)
                .font(.headline)
                .padding(.top, 4)
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color.accentColor.opacity(0.10), .clear],
                startPoint: .top, endPoint: .bottom
            )
        )
    }
}
