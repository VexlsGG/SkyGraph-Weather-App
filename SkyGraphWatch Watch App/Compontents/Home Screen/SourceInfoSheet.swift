import SwiftUI

struct SourceInfoSheet: View {
    var source: String
    var description: String
    @Binding var showSheet: Bool

    var body: some View {
        VStack(spacing: 16) {
            Capsule().frame(width: 38, height: 5)
                .foregroundColor(.gray.opacity(0.18))
                .padding(.top, 12)
            Image(systemName: "bolt.horizontal.circle.fill")
                .font(.system(size: 42))
                .foregroundColor(.accentColor)
                .padding(.bottom, 2)
            Text(source)
                .font(.headline)
            Text(description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
            Button("Close") {
                showSheet = false
            }
            .font(.headline)
            .padding(.horizontal, 18)
            .padding(.vertical, 8)
            .background(Color.accentColor.opacity(0.15))
            .cornerRadius(13)
            Spacer()
        }
        .padding(.top, 12)
        .background(Color("Background").ignoresSafeArea())
    }
}
