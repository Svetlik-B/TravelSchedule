import SwiftUI

@MainActor
final class StationSelectorViewModel: ObservableObject {
    @Published var showFromCitySelector: Bool = false
    @Published var showToCitySelector: Bool = false
    @Published var from: Station?
    @Published var to: Station?
    @Published var carriersViewModel: CarrierListPage.ViewModel?

    func toggleDirection() { (from, to) = (to, from) }
    func performSearch(from: Station, to: Station) {
        carriersViewModel = .init(
            from: from,
            to: to
        )
    }
}

struct StationSelector: View {
    @ObservedObject var viewModel = StationSelectorViewModel()
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 18) {
                VStack(spacing: 26) {
                    DirectionButton(text: viewModel.from?.name, prompt: "Откуда") {
                        viewModel.showFromCitySelector = true
                    }
                    DirectionButton(text: viewModel.to?.name, prompt: "Куда") {
                        viewModel.showToCitySelector = true
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                Button {
                    viewModel.toggleDirection()
                } label: {
                    Image(uiImage: .сhange)
                        .padding(5)
                        .background(.white)
                        .cornerRadius(100)
                }
            }
            .padding()
            .background(Color.Colors.blueUniversal)
            .cornerRadius(16)
            .padding(.horizontal)

            if let from = viewModel.from, let to = viewModel.to {
                CustomButton(text: "Найти", hasDot: false) {
                    viewModel.performSearch(from: from, to: to)
                }
                .frame(width: 150)
            }
        }
        .fullScreenCover(item: $viewModel.carriersViewModel) { carriersViewModel in
            NavigationStack {
                CarrierListPage(viewModel: carriersViewModel)
                    .customNavigationBar(title: "") { viewModel.carriersViewModel = nil }
            }
            .environment(\.colorScheme, colorScheme)
        }
        .fullScreenCover(isPresented: $viewModel.showFromCitySelector) {
            CitySelectionView(
                direction: $viewModel.from,
                showCitySelector: $viewModel.showFromCitySelector
            )
            .environment(\.colorScheme, colorScheme)
        }
        .fullScreenCover(isPresented: $viewModel.showToCitySelector) {
            CitySelectionView(
                direction: $viewModel.to,
                showCitySelector: $viewModel.showToCitySelector
            )
            .environment(\.colorScheme, colorScheme)
        }
    }

    struct CitySelectionView: View {
        @Binding var direction: Station?
        @Binding var showCitySelector: Bool
        var body: some View {
            NavigationStack {
                CitySearchPage(
                    viewModel: .init(
                        onStationSelected: { city, station in
                            direction = station
                            showCitySelector = false
                        }
                    )
                )
                .customNavigationBar(title: "Выбор города") {
                    showCitySelector = false
                }
            }
        }
    }

    struct DirectionButton: View {
        var text: String?
        var prompt: String
        var action: () -> Void
        var body: some View {
            Button(action: action) {
                HStack {
                    Text(text ?? prompt)
                        .foregroundStyle(text == nil ? Color(uiColor: .lightGray) : .black)
                        .lineLimit(1)
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    StationSelector()
}
