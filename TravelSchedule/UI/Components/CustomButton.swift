import SwiftUI

struct CustomButton: View {
    var text: String
    var hasDot: Bool = false
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            ZStack {
                Color.Colors.blueUniversal
                HStack(spacing: 4) {
                    Text(text)
                    if hasDot {
                        Circle()
                            .fill(Color.Colors.redUniversal)
                            .frame(width: 8, height: 8)
                    }
                }
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(.white)
            }
            .frame(height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

#Preview {
    CustomButton(text: "Test", hasDot: true, action: {})
        .padding()
}
