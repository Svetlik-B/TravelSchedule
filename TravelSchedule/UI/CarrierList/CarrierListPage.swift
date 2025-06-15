import SwiftUI
import OpenAPIURLSession

struct CarrierListPage: View {
    @Observable
    final class ViewModel: Identifiable {
        var id: String { from.id + "-" + to.id}
        var from: Station
        var to: Station
        var carriers = [CarrierCard.ViewModel]()
        var hasFilter = false

        func updateCarriers() async throws {
            let service = try SearchService(
                client: Client(serverURL: Servers.Server1.url(), transport: URLSessionTransport()),
                apikey: Constant.apiKey
            )
            print("from:", from)
            print("to:", to)
            let result = try await service.getSearch(
                from: from.id,
                to: to.id,
                date: Date(),
                offset: nil,
                limit: nil
            )
            print(result)
            
            // TODO: logo
            // TODO: date format
            // TODO: согласовать "часы"
            // TODO: mock
            // TODO: filter
            // TODO: more then 100
            
            
            let segments = result.segments ?? []
            carriers = segments.compactMap { segment in
                var duration = Int(segment.duration ?? 0)
                duration /= 60 * 60
                let departure = (segment.departure ?? "???").prefix(11 + 5).suffix(5)
                let arrival = (segment.arrival ?? "???").prefix(11 + 5).suffix(5)
                return CarrierCard.ViewModel(
                    id: segment.thread?.uid ?? "No id",
                    name: segment.thread?.carrier?.title ?? "No Title",
                    date: segment.start_date ?? "no start",
                    departure: String(departure),
                    duration: "\(duration) часов",
                    arrival: String(arrival)
                )
            }
            
        }

        var text : String {
            "\(from.name) -> \(to.name)"
        }
        
        init(
            from: Station,
            to: Station
        ) {
            self.from = from
            self.to = to
        }
    }
    let viewModel: ViewModel
    @State private var isLoading = false
    @State private var filterIsShown: Bool = false
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        VStack {
            Text(viewModel.text).b24
                .padding()
            if isLoading {
                Color.clear.overlay { ProgressView() }
            } else if viewModel.carriers.isEmpty {
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
                .overlay(alignment: .bottom) {
                    CustomButton(
                        text: "Уточнить время",
                        hasDot: viewModel.hasFilter
                    ) { filterIsShown = true }
                        .padding()
                }
            }
        }
        .fullScreenCover(isPresented: $filterIsShown) {
            CarrierFilterPageWrapper()
                .environment(\.colorScheme, colorScheme)
        }
        .task {
            isLoading = true
            do {
                try await viewModel.updateCarriers()
                isLoading = false
            } catch {
                print("error: \(error)")
            }
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
                from: .init(id: "s9612140", name: "Ижевск"),
                to: .init(id: "s2000003", name: "Москва (Казанский вокзал)")
            )
        )
    }
}

var mockCarriers: [CarrierCard.ViewModel] {
    makeIds(carriers: [
        .rzd,
        .fgk,
        .ural,
        .rzd,
        .fgk,
        .ural,
        .rzd,
        .fgk,
        .ural,
    ])
}

func makeIds(carriers: [CarrierCard.ViewModel]) -> [CarrierCard.ViewModel] {
    carriers.enumerated().map { index, carrier in
        carrier.with(id: "\(index)")
    }
}
