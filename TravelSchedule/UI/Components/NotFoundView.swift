import SwiftUI

struct NotFoundView: View {
    var text: String
    var body: some View {
        GeometryReader { geometry in
            Text(text).b24
                .position(
                    x: geometry.frame(in: .local).midX,
                    y: geometry.frame(in: .local).midY
                )
        }
    }
}

#Preview {
    NotFoundView(text: "Not Found")
}
