import SwiftUI

struct StationSelectionPage: View {
    struct ViewModel {
        @Binding var from: String?
        @Binding var to: String?
        @Binding var showFromCitySelector: Bool
        @Binding var showToCitySelector: Bool
    }
    var viewModel: ViewModel
    var body: some View {
        VStack(spacing: 20) {
            StoryView()
            StationSelector(viewModel: viewModel)
        }
    }
}

struct StationSelector: View {
    var viewModel: StationSelectionPage.ViewModel
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 18) {
                VStack(spacing: 26) {
                    DirectionButton(text: viewModel.from, prompt: "Откуда") { viewModel.showFromCitySelector = true }
                    DirectionButton(text: viewModel.to, prompt: "Куда") { viewModel.showToCitySelector = true }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                Button {
                    (viewModel.from, viewModel.to) = (viewModel.to, viewModel.from)
                } label: {
                    Image(uiImage: .сhange)
                        .padding(5)
                        .background(.white)
                        .cornerRadius(100)
                }
            }
            .padding()
            .background(Color.Colors.blueUniversal)
            .cornerRadius(16)
            .padding(.horizontal)

            if viewModel.from != nil && viewModel.to != nil {
                CustomButton(text: "Найти", hasDot: false) {}
                    .frame(width: 150)
            }
        }
    }
}

struct DirectionButton: View {
    var text: String?
    var prompt: String
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack {
                Text(text ?? prompt)
                    .foregroundStyle(text == nil ? Color(uiColor: .lightGray) : .black)
                    .lineLimit(1)
                Spacer()
            }
        }
    }
}
