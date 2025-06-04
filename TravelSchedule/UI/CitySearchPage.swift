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

struct CityListView: View {
    var filteredCities: [City]
    var viewModel: StationSearchViewModel
    var body: some View {
        List(filteredCities) { city in
            ZStack {
                NavigationLink {
                    StationSearchDestinationView(
                        viewModel: .init(
                            city: city,
                            list: viewModel.stationList(city),
                            onStationSelected: viewModel.onStationSelected
                        )
                    )
                } label: {
                    EmptyView()
                }
                .opacity(0)
                HStack {
                    Text(city.name)
                    Spacer()
                    Image(uiImage: .Chevron.right)
                }
            }
            .padding(.horizontal)
            .listRowSeparator(.hidden)
            .frame(height: 60)
            .listRowInsets(EdgeInsets())
        }
        .listStyle(.plain)
    }
}

struct StationSearchDestinationView: View {
    var viewModel: StationSearchPage.ViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        StationSearchPage(viewModel: viewModel)
            .customNavigationBar(
                title: "Выбор станции",
                action: { dismiss() }
            )
    }
}
