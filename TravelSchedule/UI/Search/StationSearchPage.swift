import SwiftUI

struct StationSearchPage: View {
    var city: City
    var action: (Station) -> Void
    @State private var searchText = ""
    private var filteredItems: [Station] {
        guard !searchText.isEmpty else {
            return city.stations
        }
        return city.stations.filter { item in
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
                let items = filteredItems
                    .map { ItemList.Item(id: $0.id, name: $0.name) }
                ItemList(items: items) { item in
                    let station = Station(id: item.id, name: item.name)
                    action(station)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        StationSearchPage(
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
        .navigationTitle("Выбор станции")
        .navigationBarTitleDisplayMode(.inline)
    }
}
