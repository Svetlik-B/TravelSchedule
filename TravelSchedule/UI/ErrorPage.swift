import SwiftUI

struct ErrorPage: View {
    enum Kind {
        case server
        case internet
        var image: Image {
            switch self {
            case .server: Image(uiImage: .serverError)
            case .internet: Image(uiImage: .noInternet)
            }
        }
        var text: String {
            switch self {
            case .server: "Ошибка сервера"
            case .internet: "Нет интернета"
            }
        }
    }
    var kind: Kind = .server
    var body: some View {
        VStack {
            kind.image
                .cornerRadius(70)
            Text(kind.text)
                .padding(.top, 16)
        }
        .listStyle(.plain)

    }

}

#Preview("Ошибка сервера") {
    ErrorPage(kind: .server)
}

#Preview("Нет интернета") {
    ErrorPage(kind: .internet)
}
