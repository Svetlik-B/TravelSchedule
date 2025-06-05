import SwiftUI

struct StoryListView: View {
    @State private var viewModel: StoryPage.ViewModel?
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 12) {
                ForEach(1..<10) { index in
                    Image("Content/\(index)/small")
                        .cornerRadius(12)
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
