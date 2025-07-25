import Observation
import SwiftUI

@MainActor
final class CarrierFilterPageViewModel: ObservableObject {
    let action: (Filters) -> Void
    init(action: @escaping (Filters) -> Void) {
        self.action = action
    }
    struct Filters {
        var showMorning = false
        var showDay = false
        var showEvening = false
        var showNight = false
        var showWithTransfers: Bool? = nil
    }
    @Published var filters: Filters = .init()
    var showWithTransfersYes: Bool {
        get { filters.showWithTransfers == true }
        set { filters.showWithTransfers = newValue }
    }
    var showWithTransfersNo: Bool {
        get { filters.showWithTransfers == false }
        set { filters.showWithTransfers = !newValue }
    }
    var canProceed: Bool { filters.showWithTransfers != nil }
    func proceed() { action(filters) }
}

struct CarrierFilterPage: View {
    @ObservedObject var viewModel: CarrierFilterPageViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Время отправления").b24
            Boxed(
                text: "Утро 06:00 - 12:00",
                value: $viewModel.filters.showMorning
            )
            Boxed(
                text: "День 12:00 - 18:00",
                value: $viewModel.filters.showDay
            )
            Boxed(
                text: "Вечер 18:00 - 00:00",
                value: $viewModel.filters.showEvening
            )
            Boxed(
                text: "Ночь 00:00 - 06:00",
                value: $viewModel.filters.showNight
            )
            Text("Показывать варианты с пересадками").b24
                .listRowSeparator(.hidden)
            Circled(
                text: "Да",
                value: $viewModel.showWithTransfersYes
            )
            Circled(
                text: "Нет",
                value: $viewModel.showWithTransfersNo
            )
            Spacer()
            if viewModel.canProceed {
                CustomButton(text: "Применить") { viewModel.proceed() }
                    .padding(.bottom)
            }
        }
        .padding(.horizontal)
    }
}

struct Boxed: View {
    var text: String
    @Binding var value: Bool
    var body: some View {
        Line(
            text: text,
            value: $value,
            yesImage: .check,
            noImage: .uncheck
        )
    }
}
struct Circled: View {
    var text: String
    @Binding var value: Bool
    var body: some View {
        Line(
            text: text,
            value: $value,
            yesImage: .yes,
            noImage: .no
        )
    }
}
struct Line: View {
    var text: String
    @Binding var value: Bool
    var yesImage: UIImage
    var noImage: UIImage
    var body: some View {
        HStack {
            Text(text)
            Spacer()
            Image(uiImage: value ? yesImage : noImage)
                .renderingMode(.template)
                .tint(.primary)
        }
        .frame(height: 60)
        .background(Color(uiColor: .systemBackground))
        .onTapGesture { self.value.toggle() }
    }
}

#Preview {
    let viewModel: CarrierFilterPageViewModel = {
        let viewModel = CarrierFilterPageViewModel { print("fitltes:", $0) }
        return viewModel
    }()
    NavigationStack {
        CarrierFilterPage(viewModel: viewModel)
            .navigationTitle("Test")
            .navigationBarTitleDisplayMode(.inline)
    }
}
