import SwiftUI

struct MainScreen: View {
    var body: some View {
        TabView {
            Text("Откуда")
                .tabItem {
                    Image(uiImage: .schedule)
                }
            Text("Настройки")
                .tabItem {
                    Image(uiImage: .settings)
                }
        }
        .tint(.black)
    }
}

#Preview {
    MainScreen()
}
