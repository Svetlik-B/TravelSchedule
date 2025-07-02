import SwiftUI

struct StoryListView: View {
    @State private var viewModel: StoryPageViewModel?
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 12) {
                ForEach(1..<10) { index in
                    Image("Content/\(index)/small")
                        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.Colors.blueUniversal, lineWidth: 5))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .onTapGesture { viewModel = .init(id: index) }
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 188)
        }
        .scrollIndicators(.hidden)
        .fullScreenCover(item: $viewModel) {
            StoryPage(viewModel: $0)
        }
    }
}

#Preview {
    StoryListView()
}
