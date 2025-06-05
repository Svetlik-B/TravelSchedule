import SwiftUI

struct StoryItemView: View {
    struct ViewModel {
        var imageName: String
        var title: String
        var text: String
        var progress: Double
    }
    var viewModel: ViewModel
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 16) {
                Color.clear.frame(height: 120)
                    .overlay(alignment: .bottomLeading) {
                        Text(viewModel.title).b34.lineLimit(2)
                    }
                Color.clear.frame(height: 72)
                    .overlay(alignment: .bottomLeading) {
                        Text(viewModel.text).r20.lineLimit(3)
                    }
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
        .background {
            Image(viewModel.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
        .clipShape(RoundedRectangle(cornerRadius: 40))
        .background()
        .environment(\.colorScheme, .dark)
    }
}

#Preview {
    StoryItemView(viewModel: .mock1)
}

extension StoryItemView.ViewModel {
    static let mock1: Self = .init(
        imageName: "Content/1/big1",
        title: String(repeating: "Text ", count: 50),
        text: String(repeating: "Text ", count: 50),
        progress: 0
    )
    static let mock2: Self = .init(
        imageName: "Content/1/big2",
        title: String(repeating: "Text ", count: 50),
        text: String(repeating: "Text ", count: 50),
        progress: 0
    )
}
