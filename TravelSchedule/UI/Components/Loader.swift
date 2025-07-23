import SwiftUI

struct Loader: View {
    @State var animate = false
    var body: some View {
        Image(.loader)
            .rotationEffect(.degrees(animate ? 360 : 0))
            .onAppear {
                withAnimation(
                    .linear(duration: 1)
                    .repeatForever(autoreverses: false)
                ) {
                    animate.toggle()
                }
            }
    }
}

#Preview {
    Loader()
}
