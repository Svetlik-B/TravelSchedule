import SwiftUI

final class Page: Identifiable {
    init(
        imageName: String,
        title: String = String(repeating: "Text ", count: 50),
        text: String = String(repeating: "Text ", count: 50),
        isCompleted: Bool = false
    ) {
        self.imageName = imageName
        self.title = title
        self.text = text
        self.isCompleted = isCompleted
    }
    var id: String { imageName }
    var imageName: String
    var title: String
    var text: String
    var isCompleted: Bool = false
}

final class Story: Identifiable {
    var id: String { imageName }
    init(
        imageName: String,
        pages: [Page],
        text: String = String(repeating: "Text ", count: 50)
    ) {
        self.imageName = imageName
        self.pages = pages
        self.text = text
    }
    let imageName: String
    let pages: [Page]
    let text: String
    var isCompleted: Bool { pages.allSatisfy(\.isCompleted) }
}

func createStories() -> [Story] {
    (1...9).flatMap { id in
        [
            Story(
                imageName: "Content/\(id)/small",
                pages: [
                    Page(imageName: "Content/\(id)/big1"),
                    Page(imageName: "Content/\(id)/big2"),
                ]
            )
        ]
    }
}

@MainActor
final class StoryListViewModel: ObservableObject {
    @Published var storyPageViewModel: StoryPageViewModel? {
        willSet {
            guard let oldValue = storyPageViewModel, newValue == nil else { return }
            let completed = Set(oldValue.completedIds)
            for story in stories {
                for page in story.pages {
                    if completed.contains(page.id) {
                        page.isCompleted = true
                    }
                }
            }
        }
    }
    @Published var stories: [Story] = createStories()
    var sortedStories: [Story] {
        stories.sorted { first, second in
            switch (first.isCompleted, second.isCompleted) {
            case (false, true):
                return true
            case (true, false):
                return false
            default:
                return first.id < second.id
            }
        }
    }
    func onTap(id: String) {
        let items =
            sortedStories
            .drop(while: { $0.id != id })
            .flatMap { story in
                story.pages.map { page in
                    StoryItemViewViewModel(
                        imageName: page.imageName,
                        title: page.title,
                        text: page.text,
                        progress: .init()
                    )
                }
            }
        storyPageViewModel = StoryPageViewModel(items: items)
    }
}

struct StoryListView: View {
    @ObservedObject var viewModel = StoryListViewModel()
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 12) {
                ForEach(viewModel.sortedStories) { story in
                    Image(uiImage: UIImage(named: story.imageName) ?? UIImage())
                        .overlay(alignment: .bottomLeading) {
                            Text(story.text).r12
                                .foregroundStyle(.white)
                                .lineLimit(3)
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal, 8)
                                .padding(.bottom, 12)
                        }
                        .overlay {
                            if !story.isCompleted {
                                RoundedRectangle(cornerRadius: 12).strokeBorder(
                                    Color.Colors.blueUniversal,
                                    lineWidth: 5
                                )
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .opacity(story.isCompleted ? 0.5 : 1)
                        .onTapGesture { viewModel.onTap(id: story.id) }
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 188)
        }
        .scrollIndicators(.hidden)
        .fullScreenCover(item: $viewModel.storyPageViewModel) {
            StoryPage(viewModel: $0)
        }
    }
}

#Preview {
    StoryListView(viewModel: .init())
}
