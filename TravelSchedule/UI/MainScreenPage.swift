import SwiftUI

struct MainScreenPage: View {
    enum PageTab { case search, settings }
    @State private var isDark = true
    @State private var tab = PageTab.search
    @State private var showError: ErrorKind?
    var body: some View {
        TabView(selection: $tab) {
            VStack {
                StationSelectionPage()
                Spacer()
                Divider()
            }
            .tabItem {
                Image(uiImage: .schedule)
            }
            .tag(PageTab.search)

            VStack {
                switch showError {
                case .internet:
                    Spacer()
                    ErrorPage(kind: .internet)
                case .server:
                    Spacer()
                    ErrorPage(kind: .server)
                case nil:
                    SettingsPage()
                }
                Spacer()
                Divider()
            }
            .tabItem {
                Image(uiImage: .settings)
            }
            .tag(PageTab.settings)
        }
        .onChange(of: tab) { old, new in
            if  old == .settings {
                showError = nil
            }
        }
        .tint(.primary)
        .environment(\.travelScheduleIsDarkBinding, $isDark)
        .environment(\.colorScheme, isDark ? .dark : .light)
        .environment(\.onError) { errorKind in
            tab = .settings
            showError = errorKind
        }
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

#Preview {
    MainScreenPage()
}
