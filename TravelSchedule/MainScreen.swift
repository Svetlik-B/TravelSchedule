import SwiftUI

struct MainScreen: View {
    var body: some View {
        TabView {
            VStack {
                Text("Расписание")
                Spacer()
                Divider()
            }
            .tabItem {
                Image(uiImage: .schedule)
            }
            SettingsView()
                .tabItem {
                    Image(uiImage: .settings)
                }
        }
        .tint(.primary)
    }
}

#Preview {
    MainScreen()
}
