import SwiftUI

struct StationSearchView: View {
    struct ViewModel {
        var city: City
        var list: [Station]
        var onStationSelected: (_ city: City, _ station: Station) -> Void
    }
    var viewModel: ViewModel
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
                List(filteredItems) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Image(uiImage: .Chevron.right)
                    }
                    .padding(.horizontal)
                    .listRowSeparator(.hidden)
                    .frame(height: 60)
                    .listRowInsets(EdgeInsets())
                    .onTapGesture {
                        viewModel.onStationSelected(viewModel.city, item)
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}
#Preview {
    NavigationStack {
        StationSearchView(
            viewModel: .init(
                city: .init(id: "1", name: "Москва"),
                list: [
                    .init(id: "1", name: "Киевский вокзал"),
                    .init(id: "2", name: "Курский вокзал"),
                    .init(id: "3", name: "Ярославский вокзал"),
                    .init(id: "4", name: "Белорусский вокзал"),
                    .init(id: "5", name: "Савёловский вокзал"),
                    .init(id: "6", name: "Ленинградский вокзал"),
                ],
                onStationSelected: { print("city: \($0.name), station: \($1.name)") }
            )
        )
        .navigationTitle("Выбор станции")
        .navigationBarTitleDisplayMode(.inline)
    }
}
