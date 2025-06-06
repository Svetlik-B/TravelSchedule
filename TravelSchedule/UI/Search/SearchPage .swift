import SwiftUI

struct SearchPage: View {
    struct Item: Identifiable {
        var id: String
        var text: String
    }
    @Observable
    final class ViewModel {
        var notFoundString: String = "Город не найден"
        var list: [Item] = []
        var setFilter: (String) -> Void = { _ in }
    }
    var viewModel: ViewModel
    @State var searchText = ""
    var body: some View {
        VStack {
            Spacer(minLength: 0)
            SearchField(searchText: $searchText)

            if viewModel.list.isEmpty {
                NotFoundView(text: viewModel.notFoundString)
            } else {
                List(viewModel.list) { item in
                    HStack {
                        Text(item.text)
                        Spacer()
                        Image(uiImage: .Chevron.right)
                    }
                    .padding(.horizontal)
                    .listRowSeparator(.hidden)
                    .frame(height: 60)
                    .listRowInsets(EdgeInsets())
                }
                .listStyle(.plain)

            }
        }
    }
}

#Preview {
    NavigationStack {
        CitySearchPage(viewModel: .mock { print("cityId: \($0), stationId: \($1)") })
            .navigationTitle("Выбор города")
            .navigationBarTitleDisplayMode(.inline)
    }
}
#Preview("not found") {
    NavigationStack {
        CitySearchPage(
            viewModel: .mock {
                print("cityId: \($0), stationId: \($1)")
            },
            searchText: "aaa"
        )
        .navigationTitle("Выбор города")
        .navigationBarTitleDisplayMode(.inline)
    }
}

