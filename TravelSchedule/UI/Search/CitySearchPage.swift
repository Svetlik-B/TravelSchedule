import SwiftUI
import OpenAPIRuntime

struct CitySearchPage: View {
    @Bindable var viewModel: CitySearchViewModel
    var cityLoader = CityLoader.live
    @State private var selectedCity: City?
    @State private var isWaiting: Bool = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.onError) private var onError
    var body: some View {
        VStack {
            Spacer(minLength: 0)
            SearchField(searchText: $viewModel.searchText)

            if isWaiting {
                Color.clear.overlay {
                    ProgressView()
                }
            } else if viewModel.filteredCities.isEmpty {
                NotFoundView(text: "Город не найден")
            } else {
                let items = viewModel.filteredCities
                    .map { ItemList.Item(id: $0.id, name: $0.name) }
                ItemList(items: items) { item in
                    selectedCity = viewModel.city(id: item.id)
                }
            }
        }
        .navigationDestination(item: $selectedCity) { city in
            StationSearchPage(city: city) { station in
                viewModel.onStationSelected(city, station)
            }
            .customNavigationBar(
                title: "Выбор станции",
                action: { selectedCity = nil }
            )
        }
        .task {
            isWaiting = true
            do {
                let cities = try await cityLoader.loadCities()
                viewModel.setFullList(cities: cities)
                isWaiting = false
            } catch {
                dismiss()
                guard
                    let error = error as? ClientError,
                    error.causeDescription == "Transport threw an error."
                else {
                    onError(.server)
                    return
                }
                onError(.internet)
            }
        }
    }
}

#Preview {
    NavigationStack {
        CitySearchPage(
            viewModel: .init { print("cityId: \($0), stationId: \($1)") },
            cityLoader: .mock
        )
        .navigationTitle("Выбор города")
        .navigationBarTitleDisplayMode(.inline)
    }
}
