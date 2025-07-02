import SwiftUI

@Observable
final class CustomProgressBarViewModel {
    init(value: Double = 0, isCompleted: Bool = false) {
        self.value = value
        self.isCompleted = isCompleted
    }
    var value: Double
    var isCompleted: Bool
}

struct CustomProgressBar: View {
    var viewModel: CustomProgressBarViewModel
    var body: some View {
        GeometryReader { geometry in
            if viewModel.isCompleted {
                Capsule().fill(Color.Colors.blueUniversal)
            } else {
                Capsule().fill(.white)
                Capsule().fill(Color.Colors.blueUniversal)
                    .frame(width: geometry.size.width * viewModel.value)
            }
        }
        .frame(height: 6)
    }
}

#Preview {
    CustomProgressBar(viewModel: .init(value: 0.5))
}
