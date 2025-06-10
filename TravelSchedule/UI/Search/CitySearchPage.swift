import SwiftUI

struct CitySearchPage: View {
    var viewModel: StationSearchViewModel
    @State var searchText = ""
    private var filteredCities: [City] {
        if searchText.isEmpty {
            return viewModel.shortList
        } else {
            return viewModel.fullList.filter { item in
                item.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        VStack {
            Spacer(minLength: 0)
            SearchField(searchText: $searchText)

            if filteredCities.isEmpty {
                NotFoundView(text: "Город не найден")
            } else {
                CityListView(
                    filteredCities: filteredCities,
                    viewModel: viewModel
                )
            }
        }
    }
}

struct CityListView: View {
    var filteredCities: [City]
    var viewModel: StationSearchViewModel
    @State private var stationViewModel: StationSearchPage.ViewModel?

    var body: some View {
        List(filteredCities) { city in
            HStack {
                Text(city.name)
                Spacer()
                Image(uiImage: .Chevron.right)
                    .renderingMode(.template)
            }
            .padding(.horizontal)
            .listRowSeparator(.hidden)
            .frame(height: 60)
            .listRowInsets(EdgeInsets())
            .onTapGesture {
                stationViewModel = .init(
                    city: city,
                    list: viewModel.stationList(city)
                )
            }
        }
        .listStyle(.plain)
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
