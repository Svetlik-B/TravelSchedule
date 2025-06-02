import SwiftUI

struct SearchView: View {
    struct Item: Identifiable {
        var id: String
        var name: String
    }
    struct ViewModel {
        var shortList: [Item]
        var fullList: [Item]
    }
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
//        self.filteredItems = viewModel.shortList
    }
    var viewModel: ViewModel
    @State private var searchText = ""
    private var filteredItems: [Item] {
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
            Spacer()
            SearchField(searchText: $searchText)
            
            List(filteredItems) { item in
                ZStack {
                    NavigationLink {
                        Text(item.name)
                            .navigationTitle("Выбор станции")
                        
                    } label: {
                        EmptyView()
                    }
                    .opacity(0)
                    HStack {
                        Text(item.name)
                        Spacer()
                        Image(uiImage: .Chevron.right)
                    }
                    .padding(.horizontal)
                }
                .listRowSeparator(.hidden)
                .frame(height: 60)
                .listRowInsets(EdgeInsets())
            }
            .listStyle(.plain)
        }
    }
}

private let viewModel = SearchView.ViewModel(
    shortList: [
        .init(id: "1", name: "Москва"),
        .init(id: "2", name: "Санкт Петербург"),
        .init(id: "3", name: "Сочи"),
        .init(id: "4", name: "Горный Воздух"),
        .init(id: "5", name: "Краснодар"),
        .init(id: "6", name: "Казань"),
        .init(id: "7", name: "Омск"),
    ],
    fullList: [
        .init(id: "1", name: "Москва"),
        .init(id: "2", name: "Санкт Петербург"),
        .init(id: "3", name: "Сочи"),
        .init(id: "4", name: "Горный Воздух"),
        .init(id: "5", name: "Краснодар"),
        .init(id: "6", name: "Казань"),
        .init(id: "7", name: "Омск"),
        .init(id: "8", name: "Ижевск"),
        .init(id: "9", name: "Иркутск"),
        .init(id: "10", name: "Саратов"),
    ]
)

#Preview {
    NavigationStack {
        SearchView(viewModel: viewModel)
            .navigationTitle("Выбор города")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct SearchField: View {
    @Binding var searchText: String
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            //                    .foregroundStyle(Color.gray)
                .padding(.leading, 8)
            TextField("Введите запрос", text: $searchText)
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .padding(.trailing, 8)
                        .tint(Color(uiColor: .lightGray))
                }
            }
        }
        .frame(height: 36)
        .background(Color.gray)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
