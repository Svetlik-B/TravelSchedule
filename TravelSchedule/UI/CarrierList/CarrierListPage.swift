import OpenAPIRuntime
import OpenAPIURLSession
import SwiftUI

@MainActor
final class CarrierListPageViewModel: ObservableObject, Identifiable {
    let from: Station
    let to: Station
    let dismiss: () -> Void
    let onError: (Error) -> Void
    init(
        from: Station,
        to: Station,
        dismiss: @escaping () -> Void,
        onError: @escaping (Error) -> Void
    ) {
        self.from = from
        self.to = to
        self.dismiss = dismiss
        self.onError = onError
    }

    @Published var carriers = [CarrierCard.ViewModel]()
    @Published var isLoading = false
    @Published var hasFilter = false
    @Published var filterIsShown: Bool = false
}

extension CarrierListPageViewModel {
    var text: String {
        "\(from.name) -> \(to.name)"
    }
    var hasNoCarriers: Bool {
        carriers.isEmpty
    }
    func update() async {
        isLoading = true
        do {
            try await updateCarriers()
            isLoading = false
        } catch {
            onError(error)
            dismiss()
        }
    }
    
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
            transfers: true,
            offset: nil,
            limit: nil
        )

        // TODO: logo
        // TODO: mock
        // TODO: filter
        // TODO: more then 100

        let segments = result.segments ?? []
        carriers = segments.compactMap { segment in
            var duration =
                segment.duration ?? segment.details?.compactMap(\.duration).reduce(0, +) ?? 0

            duration /= 60 * 60

            let departure = (segment.departure ?? "???").prefix(11 + 5).suffix(5)
            let arrival = (segment.arrival ?? "???").prefix(11 + 5).suffix(5)
            var comment: String?
            if let transfers = segment.transfers, !transfers.isEmpty {
                let stations = transfers.compactMap(\.title).joined(separator: ", ")
                comment = "С пересадкой (\(stations))"
            }
            var dateString = "No Date"
            if let departureDate = segment.departure,
                let date = ISO8601DateFormatter().date(from: departureDate)
            {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "d MMMM"
                dateString = dateFormatter.string(from: date)
            }
            let id = [segment.departure, segment.arrival]
                .compactMap { $0 }
                .joined(separator: " -> ")

            let name =
                segment.thread?.carrier?.title ?? segment.details?.compactMap(
                    \.thread?.carrier?.title
                ).first ?? "No Name 22"

            return CarrierCard.ViewModel(
                id: id,
                name: name,
                comment: comment,
                date: dateString,
                departure: String(departure),
                duration: duration,
                arrival: String(arrival)
            )
        }
    }

}

struct CarrierListPage: View {
    @ObservedObject var viewModel: CarrierListPageViewModel
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        VStack {
            Text(viewModel.text).b24.padding()
            if viewModel.isLoading {
                Color.clear.overlay { ProgressView() }
            } else if viewModel.hasNoCarriers {
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
                    ) { viewModel.filterIsShown = true }
                    .padding()
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.filterIsShown) {
            CarrierFilterPageWrapper()
                .environment(\.colorScheme, colorScheme)
        }
        .task { await viewModel.update() }
    }
}

struct CarrierFilterPageWrapper: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        let viewModel: CarrierFilterPageViewModel = {
            let viewModel = CarrierFilterPageViewModel()
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
                to: .init(id: "s2000003", name: "Москва (Казанский вокзал)"),
                dismiss: {},
                onError: { print("error:", $0) }
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
