import SwiftUI

struct CustomButton: View {
    enum Constant {
        static var height: CGFloat = 60
    }
    var text: String
    var hasDot: Bool = false
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            ZStack {
                Color.Colors.blueUniversal
                HStack(spacing: 4) {
                    Text(text).b17
                    if hasDot {
                        Circle()
                            .fill(Color.Colors.redUniversal)
                            .frame(width: 8, height: 8)
                    }
                }
                .foregroundStyle(.white)
            }
            .frame(height: CustomButton.Constant.height)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

#Preview {
    CustomButton(text: "Test", hasDot: true, action: {})
        .padding(16)
}
