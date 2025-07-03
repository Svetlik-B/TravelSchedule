import SwiftUI

struct StoryPage: View {
    @Observable
    final class ViewModel: Identifiable {
        var id: Int
        var items: [StoryItemView.ViewModel]
        init(id: Int) {
            self.id = id
            items = Self.createItems(id: id)
        }
    }
    var viewModel: ViewModel
    @State private var currentItem: Int = 0
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack {
            StoryHeader(progress: viewModel.items.map(\.progress))
                .padding(.top)
            Spacer()
        }
        .background {
            ForEach(0..<viewModel.items.count, id: \.self) { index in
                if currentItem == index {
                    StoryItemView(viewModel: viewModel.items[index])
                        .transition(
                            .asymmetric(
                                insertion: .move(edge: .trailing),
                                removal: .move(edge: .leading)
                            )
                        )
                }
            }
        }
        .task {
            let count = await MainActor.run { viewModel.items.count }
            let duration: Double = 1
            for index in 0 ..< count {
                await MainActor.run {
                    withAnimation(.linear(duration: duration)) {
                        viewModel.items[index].progress = 1
                    }
                }
                try? await Task.sleep(for: .seconds(duration))
                await MainActor.run {
                    if index == count - 1 {
                        dismiss()
                    } else {
                        withAnimation {
                            currentItem += 1
                        }
                    }
                }
            }
        }
    }
}

extension StoryPage.ViewModel {
    static func createItems(id: Int) -> [StoryItemView.ViewModel] {
        [
            .init(
                imageName: "Content/\(id)/big1",
                title: String(repeating: "Text ", count: 50),
                text: String(repeating: "Text ", count: 50),
                progress: 0
            ),
            .init(
                imageName: "Content/\(id)/big2",
                title: String(repeating: "Text ", count: 50),
                text: String(repeating: "Text ", count: 50),
                progress: 0
            ),
        ]
    }
}

#Preview {
    StoryPage(viewModel: .init(id: 1))
        .environment(\.colorScheme, .dark)
}
