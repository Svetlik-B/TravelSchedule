import SwiftUI

struct ItemList: View {
    struct Item: Identifiable {
        var id: String
        var name: String
    }
    var items: [Item]
    var action : (Item) -> Void
    var body: some View {
        List(items) { item in
            HStack {
                Text(item.name)
                Spacer()
                Image(uiImage: .Chevron.right)
                    .renderingMode(.template)
            }
            .padding(.horizontal)
            .listRowSeparator(.hidden)
            .frame(height: 60)
            .listRowInsets(EdgeInsets())
            .onTapGesture { action(item) }
        }
        .listStyle(.plain)
    }
}
