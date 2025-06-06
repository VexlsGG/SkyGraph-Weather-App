import SwiftUI

struct GlassBackground: UIViewRepresentable {
    var cornerRadius: CGFloat = 18

    func makeUIView(context: Context) -> UIVisualEffectView {
        let blur = UIBlurEffect(style: .systemUltraThinMaterial)
        let view = UIVisualEffectView(effect: blur)
        view.clipsToBounds = true
        view.layer.cornerRadius = cornerRadius
        return view
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
