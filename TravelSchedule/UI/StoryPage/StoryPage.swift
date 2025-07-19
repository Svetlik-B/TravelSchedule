import SwiftUI

@Observable
@MainActor
final class StoryPageViewModel: Identifiable {
    init(items: [StoryItemViewViewModel], duration: Double = 5) {
        self.items = items
        self.duration = duration
        self.animation = Animation.linear(duration: duration)
    }
    var isDone = false
    private let duration: Double
    private let animation: Animation
    private(set) var currentItem: Int = 0
    private var items: [StoryItemViewViewModel]
    private func nextItem() {
        items[currentItem].progress.isCompleted = false
        items[currentItem].progress.value = 0
        withAnimation(animation) {
            items[currentItem].progress.value = 1
        }
        let current = currentItem
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            guard let self else { return }
            if self.currentItem == current {
                self.tryNextItem()
            }
        }
    }
    
    private func tryNextItem() {
        items[currentItem].progress.isCompleted = true
        if currentItem < items.count - 1 {
            currentItem = (currentItem + 1) % items.count
            nextItem()
        } else {
            isDone = true
        }
    }
    func onTap() { tryNextItem() }
    func onSwipe(translation: CGSize) {
        if abs(translation.width) > abs(translation.height) {
            if translation.width < 0 {
                tryNextItem()
            }
        } else {
            if translation.height > 0 {
                isDone = true
            }
        }
    }
    func startTimer() { nextItem() }
    var storyHeaderViewModel: [CustomProgressBarViewModel] { items.map(\.progress) }
    var itemsCount: Int { items.count }
    func storyItemViewModel(_ index: Int) -> StoryItemViewViewModel { items[index] }
    var completedIds: [String] {
        items.filter(\.progress.isCompleted).map(\.imageName)
    }
}


struct StoryPage: View {
    var viewModel: StoryPageViewModel
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack {
            StoryHeader(progress: viewModel.storyHeaderViewModel)
                .padding(.top)
                .padding(.horizontal)
            Spacer()
        }
        .background {
            ForEach(0..<viewModel.itemsCount, id: \.self) { index in
                if viewModel.currentItem == index {
                    StoryItemView(viewModel: viewModel.storyItemViewModel(index))
                        .onTapGesture { viewModel.onTap() }
                        .gesture(
                            DragGesture(minimumDistance: 20)
                                .onEnded { viewModel.onSwipe(translation: $0.translation) }
                        )
                }
            }
        }
        .onAppear { viewModel.startTimer() }
        .onChange(of: viewModel.isDone) { _, isDone in
            if isDone { dismiss() }
        }
    }
}


// MARK: Preview
@MainActor
private func createItems(id: Int) -> [StoryItemViewViewModel] {
    (id...9).flatMap { id in
        [
            .init(
                imageName: "Content/\(id)/big1",
                title: String(repeating: "Text ", count: 50),
                text: String(repeating: "Text ", count: 50),
                progress: .init()
            ),
            .init(
                imageName: "Content/\(id)/big2",
                title: String(repeating: "Text ", count: 50),
                text: String(repeating: "Text ", count: 50),
                progress: .init()
            ),
        ]
    }
}

#Preview {
    StoryPage(viewModel: .init(items: createItems(id: 1)))
        .environment(\.colorScheme, .dark)
}
