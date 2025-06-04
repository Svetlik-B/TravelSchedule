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
                            .listRowBackground(Color.clear)
                            .background {
                                NavigationLink("") {
                                    CarrierInfoPageWrapper()
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
            CarrierFilterPageWrapper()
        }
    }
}

struct CarrierFilterPageWrapper: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        let viewModel: CarrierFilterPage.ViewModel = {
            let viewModel = CarrierFilterPage.ViewModel()
            viewModel.proceed = { dismiss() }
            return viewModel
        }()
        NavigationStack {
            CarrierFilterPage(viewModel: viewModel)
                .customNavigationBar(title: "") {
                    dismiss()
                }
        }
    }
}

struct CarrierInfoPageWrapper: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        let viewModel: CarrierInfoPage.ViewModel = {
            let viewModel = CarrierInfoPage.ViewModel.init(
                logo: nil,
                name: "ОАО «РЖД»",
                email: "I.Lozgkina@yandex.ru",
                phone: "+7 (904) 329-27-71"
            )
            return viewModel
        }()
        CarrierInfoPage(viewModel: viewModel)
            .customNavigationBar(
                title: "Информация о перевозчике",
                action: { dismiss() }
            )
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
