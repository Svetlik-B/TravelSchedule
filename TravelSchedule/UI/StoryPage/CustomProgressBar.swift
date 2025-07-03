import SwiftUI

struct CustomProgressBar: View {
    var value: Double
    var body: some View {
        GeometryReader { geometry in
            Capsule().fill(.white)
                .frame(height: 6)
            Capsule().fill(Color.Colors.blueUniversal)
                .frame(width: geometry.size.width * value, height: 6)
        }
        .frame(height: 6)
    }
}

#Preview {
    CustomProgressBar(value: 0.5)
}
