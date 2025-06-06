import Observation
import SwiftUI

struct CarrierInfoPage: View {
    @Observable
    final class ViewModel {
        var logo: UIImage?
        var name: String
        var email: String?
        var phone: String?
        init(logo: UIImage? = nil, name: String, email: String?, phone: String?) {
            self.logo = logo
            self.name = name
            self.email = email
            self.phone = phone
        }
        
        var emailUrl: URL? {
            guard let email else { return nil }
            return URL(string: "mailto://\(email)")
        }
        var phoneUrl: URL? {
            guard let phone else { return nil }
            return URL(string: "tel://\(phone)")
        }
    }
    var viewModel: ViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Spacer()
                .frame(height: 2)
            Image(uiImage: .checker)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 104)
                .clipShape(RoundedRectangle(cornerRadius: 24))
            VStack(alignment: .leading, spacing: 16) {
                Text(viewModel.name).b24
                VStack(alignment: .leading, spacing: 0) {
                    if let email = viewModel.email {
                        Contact(
                            title: "E-mail",
                            text: email,
                            url: viewModel.emailUrl
                        )
                    }
                    if let phone = viewModel.phone {
                        Contact(
                            title: "Телефон",
                            text: phone,
                            url: viewModel.phoneUrl
                        )
                    }
                }
            }
            Spacer()
        }
        .padding(.horizontal)
    }
    
    struct Contact: View {
        var title: String
        var text: String
        var url: URL?
        var body: some View {
            VStack(alignment: .leading, spacing: -2) {
                Text(title).r17
                if let url {
                    Link(text, destination: url).r12
                } else {
                    Text(text).r12
                }
            }
            .frame(height: 60)
        }
    }
}



#Preview {
    NavigationStack {
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
            .navigationTitle("Информация о перевозчике")
            .navigationBarTitleDisplayMode(.inline)
    }
}
