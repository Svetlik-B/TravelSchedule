import OpenAPIRuntime
import SwiftUI

@MainActor
final class MainScreenPageViewModel: ObservableObject {
    init(
        colorScheme: ColorScheme = UIScreen.colorScheme,
        currentTab: PageTab = PageTab.search,
        showError: ErrorKind? = nil
    ) {
        self.colorScheme = colorScheme
        self.currentTab = currentTab
        self.showError = showError
        self.settings = SettingsPageViewModel(
            colorScheme: colorScheme,
            showUserAgreement: false
        )
        self.settings.setColorScheme = { [weak self] in
            self?.colorScheme = $0
        }
    }

    enum PageTab { case search, settings }

    @Published var colorScheme: ColorScheme
    @Published var currentTab = PageTab.search {
        didSet {
            if currentTab == .search {
                showError = nil
            }
        }
    }
    @Published var showError: ErrorKind?

    @Published var settings: SettingsPageViewModel

    func onError(_ error: Error) {
        // убрать все popups
        if let error = error as? ClientError {
            let underlyingError = error.underlyingError as NSError
            if underlyingError.code == -999 {
                print("Cancelled by user")
                return
            }
            showError = .server
            currentTab = .settings
            return
        }
        print("Got error:", error)
        showError = .internet
        currentTab = .settings
    }
}

struct MainScreenPage: View {
    @ObservedObject var viewModel = MainScreenPageViewModel()
    var body: some View {
        TabView(selection: $viewModel.currentTab) {
            VStack {
                StationSelectionPage(onError: viewModel.onError)
                Spacer()
                Divider()
            }
            .tabItem {
                Image(uiImage: .schedule)
            }
            .tag(MainScreenPageViewModel.PageTab.search)

            VStack {
                switch viewModel.showError {
                case nil:
                    SettingsPage(viewModel: viewModel.settings)
                case .internet:
                    Spacer()
                    ErrorPage(kind: .internet)
                case .server:
                    Spacer()
                    ErrorPage(kind: .server)
                }
                Spacer()
                Divider()
            }
            .tabItem {
                Image(uiImage: .settings)
            }
            .tag(MainScreenPageViewModel.PageTab.settings)
        }
        .tint(.primary)
        .environment(\.colorScheme, viewModel.colorScheme)
        .environment(\.onError, viewModel.onError)
    }
}

enum ErrorKind: Error {
    case internet
    case server
}

extension EnvironmentValues {
    @Entry var onError: (Error) -> Void = {
        print("Error: \($0)")
    }
}

extension UIScreen {
    fileprivate static var colorScheme: ColorScheme {
        main.traitCollection.userInterfaceStyle != .light ? .dark : .light
    }
}

#Preview {
    MainScreenPage(
        viewModel: .init(
            currentTab: .settings
        )
    )
}
