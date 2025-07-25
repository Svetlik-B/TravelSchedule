import SwiftUI

@MainActor
final class StationSearchPageViewModel: ObservableObject {
    private var city: City
    private var action: (Station) -> Void
    init(city: City, action: @escaping (Station) -> Void) {
        self.city = city
        self.action = action
    }
    @Published var searchText = ""
    private var filteredItems: [Station] {
        guard !searchText.isEmpty else {
            return city.stations
        }
        return city.stations.filter { item in
            item.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    var noStationsFound: Bool { filteredItems.isEmpty }
    var items: [ItemList.Item] {
        filteredItems.map { ItemList.Item(id: $0.id, name: $0.name) }
    }
    func onSelect(item: ItemList.Item) {
        let station = Station(id: item.id, name: item.name)
        action(station)
    }
}

struct StationSearchPage: View {
    @ObservedObject var viewModel: StationSearchPageViewModel
    var body: some View {
        VStack {
            Spacer()
            SearchField(searchText: $viewModel.searchText)

            if viewModel.noStationsFound {
                NotFoundView(text: "Станция не найдена")
            } else {
                ItemList(items: viewModel.items) { viewModel.onSelect(item: $0) }
            }
        }
    }
}

#Preview {
    NavigationStack {
        StationSearchPage(
            viewModel: .init(
                city: .init(
                    id: "1",
                    name: "Москва",
                    stations: [
                        .init(id: "1", name: "Киевский вокзал"),
                        .init(id: "2", name: "Курский вокзал"),
                        .init(id: "3", name: "Ярославский вокзал"),
                        .init(id: "4", name: "Белорусский вокзал"),
                        .init(id: "5", name: "Савёловский вокзал"),
                        .init(id: "6", name: "Ленинградский вокзал"),
                    ]
                )
            ) { print("station: \($0.name)") }
        )
        .navigationTitle("Выбор станции")
        .navigationBarTitleDisplayMode(.inline)
    }
}
