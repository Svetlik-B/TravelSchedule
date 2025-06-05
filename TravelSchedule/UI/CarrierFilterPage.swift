import SwiftUI
import Observation

struct CarrierFilterPage: View {
    @Observable
    final class ViewModel {
        var showMorning = false
        var showDay = false
        var showEvening = false
        var showNight = false
        var showWithTransfers: Bool? = nil
        var showWithTransfersYes: Bool {
            get { showWithTransfers == true }
            set { showWithTransfers = newValue }
        }
        var showWithTransfersNo: Bool {
            get { showWithTransfers == false }
            set { showWithTransfers = !newValue }
        }
        var canProceed: Bool { showWithTransfers != nil }
        var proceed: () -> Void = {}
    }

    @Bindable var viewModel: ViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Время отправления").b24
            Boxed(
                text: "Утро 06:00 - 12:00",
                value: $viewModel.showMorning
            )
            Boxed(
                text: "День 12:00 - 18:00",
                value: $viewModel.showDay
            )
            Boxed(
                text: "Вечер 18:00 - 00:00",
                value: $viewModel.showEvening
            )
            Boxed(
                text: "Ночь 00:00 - 06:00",
                value: $viewModel.showNight
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
        HStack{
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
    let viewModel: CarrierFilterPage.ViewModel = {
        let viewModel = CarrierFilterPage.ViewModel()
        viewModel.proceed = { print("Поехали!") }
        return viewModel
    }()
    NavigationStack {
        CarrierFilterPage(viewModel: viewModel)
            .navigationTitle("Test")
            .navigationBarTitleDisplayMode(.inline)
    }
}

