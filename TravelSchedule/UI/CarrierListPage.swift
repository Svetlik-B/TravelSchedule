import SwiftUI

struct CarrierListPage: View {
    struct ViewModel {
        var text: String
        var carriers: [CarrierCard.ViewModel]
        var hasFilter: Bool
    }
    var viewModel: ViewModel
    @State private var filterIsShown: Bool = false
    var body: some View {
        VStack {
            Text(viewModel.text).b24
                .padding()
            if viewModel.carriers.isEmpty {
                NotFoundView(text: "Вариантов нет")
                    .offset(y: -CustomButton.Constant.height)
            } else {
                List {
                    ForEach(viewModel.carriers) { carrier in
                        CarrierCard(viewModel: carrier)
                            .listRowSeparator(.hidden)
                            .listRowInsets(
                                .init(
                                    top: 0,
                                    leading: 16,
                                    bottom: 0,
                                    trailing: 16
                                )
                            )
                            .background {
                                NavigationLink {
                                    Text(carrier.name)
                                } label: {

                                }
                            }
                    }
                    Spacer().frame(height: CustomButton.Constant.height)
                }
                .listRowSpacing(8)
                .listStyle(.plain)
            }
        }
        .overlay(alignment: .bottom) {
            CustomButton(
                text: "Уточнить время",
                hasDot: viewModel.hasFilter
            ) { filterIsShown = true }
            .padding()
        }
        .fullScreenCover(isPresented: $filterIsShown) {
            NavigationStack {
                Text("TODO")
                    .standardNavigationBar(title: "") {
                        filterIsShown = false
                    }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CarrierListPage(
            viewModel: .init(
                text: """
                    Москва (Ярославский вокзал) → Санкт Петербург (Балтийский вокзал) 
                    """,
                carriers: makeIds(carriers: [
                    .rzd,
                    .fgk,
                    .ural,
                    .rzd,
                    .fgk,
                    .ural,
                    .rzd,
                    .fgk,
                    .ural,
                ]),
                hasFilter: false
            )
        )
    }
}

func makeIds(carriers: [CarrierCard.ViewModel]) -> [CarrierCard.ViewModel] {
    carriers.enumerated().map { index, carrier in
        carrier.with(id: "\(index)")
    }
}

#Preview("Вариантов нет") {
    CarrierListPage(
        viewModel: .init(
            text: "Москва (Ярославский вокзал)" + " → Санкт Петербург (Балтийский вокзал)",
            carriers: [],
            hasFilter: true
        )
    )
}
