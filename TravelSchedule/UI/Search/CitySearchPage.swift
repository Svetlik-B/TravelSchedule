import SwiftUI

struct CitySearchPage: View {
    @Bindable var viewModel: StationSearchViewModel
    @State private var stationViewModel: StationSearchPage.ViewModel?
    var body: some View {
        VStack {
            Spacer(minLength: 0)
            SearchField(searchText: $viewModel.searchText)

            if viewModel.filteredCities.isEmpty {
                NotFoundView(text: "Город не найден")
            } else {
                let items = viewModel.filteredCities
                    .map { ItemList.Item(id: $0.id, name: $0.name) }
                ItemList(items: items) { item in
                    let city = City(id: item.id, name: item.name)
                    stationViewModel = .init(
                        city: city,
                        list: viewModel.stationList(city)
                    )
                }
            }
        }
        .navigationDestination(item: $stationViewModel) { stationVM in
            StationSearchPage(viewModel: stationVM) { station in
                viewModel.onStationSelected(stationVM.city, station)
            }
            .customNavigationBar(
                title: "Выбор станции",
                action: { stationViewModel = nil }
            )
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
