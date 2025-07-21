import SwiftUI

@MainActor
final class CitySearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var isWaiting: Bool = false
    @Published var selectedCity: City?

    private var fullList = [City]()
    private let cityLoader: CityLoader

    var onStationSelected: (City, Station) -> Void
    var dismiss: () -> Void
    var onError: (Error) -> Void

    init(
        cityLoader: CityLoader = .live,
        dismiss: @escaping () -> Void,
        onError: @escaping (Error) -> Void,
        onStationSelected: @escaping (City, Station) -> Void
    ) {
        self.cityLoader = cityLoader
        self.dismiss = dismiss
        self.onError = onError
        self.onStationSelected = onStationSelected
    }
}

// MARK: Interface
extension CitySearchViewModel {
    var filteredCities: [City] {
        if searchText.isEmpty {
            return Self.shortListCitiesNames
                .compactMap { name in
                    fullList.first(where: { city in
                        city.name == name
                    })
                }
        } else {
            return fullList.filter { item in
                item.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    var cityItems: [ItemList.Item] {
        filteredCities
            .map { ItemList.Item(id: $0.id, name: $0.name) }
    }
    func onSelected(item: ItemList.Item) {
        selectedCity = city(id: item.id)
    }
}

// MARK: Implementation
extension CitySearchViewModel {
    fileprivate func loadStations() async {
        do {
            isWaiting = true
            fullList = try await cityLoader.loadCities()
            isWaiting = false
        } catch {
            dismiss()
            onError(error)
        }

    }
    fileprivate func city(id: String) -> City? {
        fullList.first(where: { $0.id == id })
    }
}

extension CitySearchViewModel {
    fileprivate static let shortListCitiesNames: [String] = [
        "Москва",
        "Санкт Петербург",
        "Сочи",
        "Горный Воздух",
        "Краснодар",
        "Казань",
        "Омск",
    ]
}

struct CitySearchPage: View {
    @ObservedObject var viewModel: CitySearchViewModel
    var body: some View {
        VStack {
            Spacer(minLength: 0)
            SearchField(searchText: $viewModel.searchText)

            if viewModel.isWaiting {
                Color.clear.overlay {
                    ProgressView()
                }
            } else if viewModel.filteredCities.isEmpty {
                NotFoundView(text: "Город не найден")
            } else {
                ItemList(
                    items: viewModel.cityItems,
                    action: viewModel.onSelected
                )
            }
        }
        .navigationDestination(item: $viewModel.selectedCity) { city in
            StationSearchPage(city: city) { station in
                viewModel.onStationSelected(city, station)
            }
            .customNavigationBar(
                title: "Выбор станции",
                action: { viewModel.selectedCity = nil }
            )
        }
        .task { await viewModel.loadStations() }
    }
}

#Preview {
    NavigationStack {
        CitySearchPage(
            viewModel: .init(
                cityLoader: .mock,
                dismiss: {},
                onError: { print($0) },
                onStationSelected: { city, station in
                    print(
                        """
                        Выбрано:
                            city: \(city.name)
                            station: \(station.name)
                        """
                    )
                }
            )
        )
        .navigationTitle("Выбор города")
        .navigationBarTitleDisplayMode(.inline)
    }
}
