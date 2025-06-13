import SwiftUI
//import UIKit
import WebKit

struct UserAgreementView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        SwiftWebView()
    }
}

private struct SwiftWebView: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences.preferredContentMode = .mobile
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.overrideUserInterfaceStyle = .dark
        let url = URL(string: "https://yandex.ru/legal/practicum_offer/")!
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

#Preview {
    UserAgreementView()
}
