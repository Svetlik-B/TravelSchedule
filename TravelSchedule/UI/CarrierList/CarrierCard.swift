import SwiftUI

struct CarrierCard: View {
    struct ViewModel: Identifiable {
        var id: String
        var logo: UIImage?
        var name: String
        var comment: String?
        var date: String
        var departure: String
        var duration: String
        var arrival: String
    }
    var viewModel: ViewModel
    var body: some View {
        VStack(spacing: 4) {
            Spacer().frame(height: 10)
            HStack {
                Image(uiImage: viewModel.logo ?? .checker)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 38, height: 38)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                VStack(alignment: .leading) {
                    Text(viewModel.name).r17
                    Text(viewModel.comment ?? "").r12
                        .foregroundStyle(Color.Colors.redUniversal)
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
                Text(viewModel.duration).r12
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)
                Text(viewModel.arrival).r17
            }
            .frame(height: 48)
        }
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

extension CarrierCard.ViewModel {
    static let rzd = Self(
        id: "",
        logo: .rzd,
        name: "РЖД",
        comment: "С пересадкой в Костроме",
        date: "14 января",
        departure: "22:30",
        duration: "20 часов",
        arrival: "08:15",
    )
    static let fgk = Self(
        id: "",
        logo: .fgk,
        name: "ФГК",
        comment: nil,
        date: "15 января",
        departure: "01:15",
        duration: "9 часов",
        arrival: "09:00",
    )
    static let ural = Self(
        id: "",
        logo: .ural,
        name: "Урал логистика",
        comment: nil,
        date: "16 января",
        departure: "12:30",
        duration: "9 часов",
        arrival: "21:00",
    )
    func with(id: String) -> Self {
        var copy = self
        copy.id = id
        return copy
    }
    var noLogo: Self {
        var copy = self
        copy.logo = nil
        return copy
    }
    var noComment: Self {
        var copy = self
        copy.comment = nil
        return copy
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
