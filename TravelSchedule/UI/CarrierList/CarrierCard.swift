import OpenAPIURLSession
import SwiftUI

@MainActor
final class CarrierCardViewModel: Identifiable, ObservableObject {
    init(
        code: Int? = nil,
        logo: UIImage? = nil,
        comment: String? = nil,
        date: String,
        departure: String,
        duration: Int,
        arrival: String,
        onError: @escaping (Error) -> Void
    ) {
        self.code = code
        self.logo = logo
        self.comment = comment
        self.date = date
        self.departure = departure
        self.duration = duration
        self.arrival = arrival
        self.onError = onError
    }
    let onError: (Error) -> Void
    @Published var code: Int?
    @Published var logo: UIImage?
    @Published var name: String?
    @Published var comment: String?
    @Published var date: String
    @Published var departure: String
    @Published var duration: Int
    @Published var arrival: String

    func updateLogo() async {
        guard
            name == nil,
            let code
        else { return }

        do {
            let service = try CarrierInformationService(
                client: Client(
                    serverURL: Servers.Server1.url(),
                    transport: URLSessionTransport()
                ),
                apikey: Constant.apiKey
            )
            let result = try await service.getCarrierInformation(code: "\(code)")
            name = result.carrier?.title
            
            if
                let logoURl = result.carrier?.logo,
                let url = URL(string: logoURl)
            {
                let (data, _) = try await URLSession.shared.data(from: url)
                logo = UIImage(data: data)
            }
        } catch {
            onError(error)
        }
    }
}

struct CarrierCard: View {
    @ObservedObject var viewModel: CarrierCardViewModel
    var body: some View {
        VStack(spacing: 4) {
            Spacer().frame(height: 10)
            HStack {
                Image(uiImage: viewModel.logo ?? .checker)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 38, height: 38)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                VStack(alignment: .leading) {
                    Text(viewModel.name ?? "").r17.padding(.trailing, 40)
                    if let comment = viewModel.comment {
                        Text(comment).r12
                            .foregroundStyle(Color.Colors.redUniversal)
                    }
                }
                Spacer()
            }
            .overlay(alignment: .topTrailing) {
                Text(viewModel.date).r12
                    .offset(x: 8)
            }
            .frame(height: 38)
            HStack {
                Text(viewModel.departure).r17
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)
                Text("\(viewModel.duration) часов").r12
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)
                Text(viewModel.arrival).r17
            }
            .frame(height: 48)
        }
        .task { await viewModel.updateLogo() }
        .foregroundStyle(.black)
        .padding(.horizontal, 14)
        .background(Color.Colors.lightGray)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .listRowSeparator(.hidden)
        .listRowInsets(
            .init(
                top: 0,
                leading: 16,
                bottom: 0,
                trailing: 16
            )
        )
    }
}

extension CarrierCardViewModel {
    static let rzd = CarrierCardViewModel(
        logo: .rzd,
//        name: "РЖД и еще что-то очень длинное",
        comment: "С пересадкой в Костроме",
        date: "14 января",
        departure: "22:30",
        duration: 1,
        arrival: "08:15",
        onError: { _ in }
    )
    static let fgk = CarrierCardViewModel(
        logo: .fgk,
//        name: "ФГК",
        comment: "test",
        date: "15 января",
        departure: "01:15",
        duration: 22,
        arrival: "09:00",
        onError: { _ in }
    )
    static let ural = CarrierCardViewModel(
        logo: .ural,
//        name: "Урал логистика",
        comment: nil,
        date: "16 января",
        departure: "12:30",
        duration: 5,
        arrival: "21:00",
        onError: { _ in }
    )
    var noLogo: Self {
        logo = nil
        return self
    }
    var noComment: Self {
        comment = nil
        return self
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 8) {
            CarrierCard(viewModel: .rzd)
            CarrierCard(viewModel: .fgk)
            CarrierCard(viewModel: .ural)
            CarrierCard(viewModel: .ural.noLogo)
            CarrierCard(viewModel: .rzd.noComment)
        }
    }
    .padding()
}
