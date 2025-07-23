import Observation
import OpenAPIURLSession
import SwiftUI

@MainActor
final class CarrierInfoPageViewModel: ObservableObject {
    let code: Int?
    let onError: (Error) -> Void
    init(
        code: Int?,
        onError: @escaping (Error) -> Void
    ) {
        self.code = code
        self.onError = onError
    }
    @Published var logo: UIImage?
    @Published var name: String?
    @Published var email: String?
    @Published var phone: String?

    var emailUrl: URL? {
        guard let email else { return nil }
        return URL(string: "mailto://\(email)")
    }
    var phoneUrl: URL? {
        guard let phone else { return nil }
        return URL(string: "tel://\(phone)")
    }
    func update() async {
        guard let code, name == nil
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
            email = result.carrier?.email
            phone = result.carrier?.phone

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

struct CarrierInfoPage: View {
    @ObservedObject var viewModel: CarrierInfoPageViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Spacer()
                .frame(height: 2)
            if let logo = viewModel.logo {
                Image(uiImage: logo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 104)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
            } else {
                Image(uiImage: .checker)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 104)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
            }
            VStack(alignment: .leading, spacing: 16) {
                Text(viewModel.name ?? "").b24
                VStack(alignment: .leading, spacing: 0) {
                    Contact(
                        title: "E-mail",
                        text: viewModel.email,
                        url: viewModel.emailUrl
                    )
                    Contact(
                        title: "Телефон",
                        text: viewModel.phone,
                        url: viewModel.phoneUrl
                    )
                }
            }
            Spacer()
        }
        .padding(.horizontal)
        .task { await viewModel.update() }
    }

    struct Contact: View {
        var title: String
        var text: String?
        var url: URL?
        var body: some View {
            VStack(alignment: .leading, spacing: -2) {
                Text(title).r17
                if let url {
                    Link(text ?? "", destination: url).r12
                } else {
                    Text(text ?? "").r12
                }
            }
            .frame(height: 60)
        }
    }
}

#Preview("Таврия") {
    NavigationStack {
        CarrierInfoPage(
            viewModel: CarrierInfoPageViewModel(code: 63438) {
                print("error:", $0)
            }
        )
        .navigationTitle("Информация о перевозчике")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview("РЖД") {
    NavigationStack {
        CarrierInfoPage(
            viewModel: CarrierInfoPageViewModel(code: 112) {
                print("error:", $0)
            }
        )
        .navigationTitle("Информация о перевозчике")
        .navigationBarTitleDisplayMode(.inline)
    }
}
