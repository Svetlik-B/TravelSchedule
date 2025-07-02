import SwiftUI

@Observable
final class MainScreenPageViewModel {
    init(
        colorScheme: ColorScheme = UIScreen.colorScheme,
        currentTab: PageTab = PageTab.search,
        showError: ErrorKind? = nil,
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

    var colorScheme: ColorScheme
    var currentTab = PageTab.search {
        didSet {
            if currentTab == .search {
                showError = nil
            }
        }
    }
    var showError: ErrorKind?
    
    var settings: SettingsPageViewModel

    func onError(_ error: ErrorKind) {
        // убрать все popups
        showError = error
        currentTab = .settings
    }
}

struct MainScreenPage: View {
    @Bindable var viewModel = MainScreenPageViewModel()
    var body: some View {
        TabView(selection: $viewModel.currentTab) {
            VStack {
                StationSelectionPage()
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

enum ErrorKind {
    case internet
    case server
}

extension EnvironmentValues {
    @Entry var onError: (ErrorKind) -> Void = {
        print("ErrorKind: \($0)")
    }
}

extension UIScreen {
    fileprivate static var colorScheme: ColorScheme { main.traitCollection.userInterfaceStyle != .light ? .dark : .light
    }
}

#Preview {
    MainScreenPage(
        viewModel: .init(
            currentTab: .settings,
           //showError: .server,
        )
    )
}
