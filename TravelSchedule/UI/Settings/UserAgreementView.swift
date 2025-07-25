import SwiftUI
import WebKit

struct UserAgreementView: View {
    let onError: (Error) -> Void
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        SwiftWebView {
            dismiss()
            onError($0)
        }
    }
}

private struct SwiftWebView: UIViewRepresentable {
    var onError: (Error) -> Void = { _ in }
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: SwiftWebView
        init(parent: SwiftWebView) {
            self.parent = parent
        }
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.onError(error)
        }
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: any Error) {
            parent.onError(error)
        }
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    func makeUIView(context: Context) -> some UIView {
        let webView = WKWebView()
        let url = URL(string: "https://yandex.ru/legal/practicum_offer/")!
        let request = URLRequest(url: url)
        webView.navigationDelegate = context.coordinator
        webView.load(request)
        return webView
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

#Preview {
    UserAgreementView {
        print("error:", $0)
    }
}
