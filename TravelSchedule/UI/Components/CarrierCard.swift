import SwiftUI

struct CarrierCard: View {
    struct ViewModel {
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
        .padding(.horizontal, 14)
        .background(Color.Colors.lightGray)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 8) {
            CarrierCard(
                viewModel: .init(
                    logo: .rzd,
                    name: "РЖД",
                    comment: "С пересадкой в Костроме",
                    date: "14 января",
                    departure: "22:30",
                    duration: "20 часов",
                    arrival: "08:15",
                )
            )
            CarrierCard(
                viewModel: .init(
                    logo: .fgk,
                    name: "ФГК",
                    comment: nil,
                    date: "15 января",
                    departure: "01:15",
                    duration: "9 часов",
                    arrival: "09:00",
                )
            )
            CarrierCard(
                viewModel: .init(
                    logo: .ural,
                    name: "Урал логистика",
                    comment: nil,
                    date: "16 января",
                    departure: "12:30",
                    duration: "9 часов",
                    arrival: "21:00",
                )
            )
            CarrierCard(
                viewModel: .init(
                    logo: nil,
                    name: "no logo",
                    comment: nil,
                    date: "16 января",
                    departure: "12:30",
                    duration: "9 часов",
                    arrival: "21:00",
                )
            )
        }
    }
    .padding()
}
