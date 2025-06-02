import SwiftUI

struct NotFoundView: View {
    var text: String
    var body: some View {
        GeometryReader { geometry in
            Text(text)
                .font(.system(size: 24, weight: .bold))
                .position(
                    x: geometry.frame(in: .local).midX,
                    y: geometry.frame(in: .local).midY
                )
        }
    }
}
