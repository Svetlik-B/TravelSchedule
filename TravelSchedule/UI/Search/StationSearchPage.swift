import SwiftUI

struct StationSearchPage: View {
    struct ViewModel: Equatable, Hashable {
        var city: City
        var list: [Station]
    }
    var viewModel: ViewModel
    var action: (Station) -> Void
    @State private var searchText = ""
    private var filteredItems: [Station] {
        guard !searchText.isEmpty else {
            return viewModel.list
        }
        return viewModel.list.filter { item in
            item.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    var body: some View {
        VStack {
            Spacer()
            SearchField(searchText: $searchText)

            if filteredItems.isEmpty {
                NotFoundView(text: "Станция не найдена")
            } else {
                List(filteredItems) { station in
                    HStack {
                        Text(station.name)
                        Spacer()
                        Image(uiImage: .Chevron.right)
                    }
                    .padding(.horizontal)
                    .listRowSeparator(.hidden)
                    .frame(height: 60)
                    .listRowInsets(EdgeInsets())
                    .onTapGesture {
                        action(station)
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}
#Preview {
    NavigationStack {
        StationSearchPage(
            viewModel: .init(
                city: .init(id: "1", name: "Москва"),
                list: [
                    .init(id: "1", name: "Киевский вокзал"),
                    .init(id: "2", name: "Курский вокзал"),
                    .init(id: "3", name: "Ярославский вокзал"),
                    .init(id: "4", name: "Белорусский вокзал"),
                    .init(id: "5", name: "Савёловский вокзал"),
                    .init(id: "6", name: "Ленинградский вокзал"),
                ]
            )
        ) { print("station: \($0.name)") }
        .navigationTitle("Выбор станции")
        .navigationBarTitleDisplayMode(.inline)
    }
}
