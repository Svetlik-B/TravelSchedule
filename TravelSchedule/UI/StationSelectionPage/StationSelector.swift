import SwiftUI

struct StationSelector: View {
    @State private var showFromCitySelector: Bool = false
    @State private var showToCitySelector: Bool = false
    @State private var carriersViewModel: CarrierListPage.ViewModel?
    @State private var from: Station?
    @State private var to: Station?
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 18) {
                VStack(spacing: 26) {
                    DirectionButton(text: from?.name, prompt: "Откуда") { showFromCitySelector = true }
                    DirectionButton(text: to?.name, prompt: "Куда") { showToCitySelector = true }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                Button {
                    (from, to) = (to, from)
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

            if let from, let to {
                CustomButton(text: "Найти", hasDot: false) {
                    carriersViewModel = .init(
                        from: from,
                        to: to,
                    )
                }
                .frame(width: 150)
            }
        }
        .fullScreenCover(item: $carriersViewModel) { viewModel in
            NavigationStack {
                CarrierListPage( viewModel: viewModel)
                .customNavigationBar(title: "") { carriersViewModel = nil }
            }
            .environment(\.colorScheme, colorScheme)
        }
        .fullScreenCover(isPresented: $showFromCitySelector) {
            CitySelectionModal(
                direction: $from,
                showCitySelector: $showFromCitySelector
            )
            .environment(\.colorScheme, colorScheme)
        }
        .fullScreenCover(isPresented: $showToCitySelector) {
            CitySelectionModal(
                direction: $to,
                showCitySelector: $showToCitySelector
            )
            .environment(\.colorScheme, colorScheme)
        }
    }
    
    struct CitySelectionModal: View {
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
