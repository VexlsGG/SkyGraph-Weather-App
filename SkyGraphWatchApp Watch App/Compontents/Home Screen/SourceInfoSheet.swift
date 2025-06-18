import SwiftUI

struct SourceInfoSheet: View {
    var source: String
    var description: String
    @Binding var showSheet: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Capsule()
                    .fill(Color.white.opacity(0.25))
                    .frame(width: 40, height: 5)
                    .padding(.top, 12)

                Image(systemName: "bolt.horizontal.circle.fill")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.accentColor)
                    .shadow(radius: 4)

                Text(source)
                    .font(.title3.bold())
                    .foregroundColor(.primary)

                Text(description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 20)

                Button {
                    showSheet = false
                } label: {
                    Text("Close")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.accentColor.opacity(0.3), lineWidth: 1)
                        )
                        .cornerRadius(16)
                        .padding(.horizontal, 40)
                }

                Spacer()
            }
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
    }
}
