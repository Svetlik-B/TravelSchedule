import SwiftUI

struct MainScreen: View {
    var body: some View {
        TabView {
            VStack(spacing: 20) {
                StoryView()
                StationSelector()
                Spacer()
                Divider()
            }
            .tabItem {
                Image(uiImage: .schedule)
            }
            VStack {
                SettingsView()
                Divider()
            }
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

struct StationSelector: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 18) {
                VStack(spacing: 26) {
                    HStack {
                        Text("Откуда")
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    HStack {
                        Text("Куда")
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                Image(uiImage: .сhange)
                    .padding(5)
                    .background(.white)
                    .cornerRadius(100)
            }
            .padding()
            .background(Color.Colors.blueUniversal)
            .cornerRadius(16)
            .padding(.horizontal)
            
            Button(action: {}) {
                ZStack {
                    Color.Colors.blueUniversal
                    Text("Найти")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(.white)
                }
                .frame(width: 150, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

struct StoryView: View {
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 12) {
                Spacer(minLength: 4)
                Image(uiImage: .Content._1.small)
                    .cornerRadius(12)
                Image(uiImage: .Content._2.small)
                    .cornerRadius(12)
                Image(uiImage: .Content._3.small)
                    .cornerRadius(12)
                Image(uiImage: .Content._4.small)
                    .cornerRadius(12)
                Image(uiImage: .Content._5.small)
                    .cornerRadius(12)
                Image(uiImage: .Content._6.small)
                    .cornerRadius(12)
                Image(uiImage: .Content._7.small)
                    .cornerRadius(12)
                Image(uiImage: .Content._8.small)
                    .cornerRadius(12)
                Image(uiImage: .Content._9.small)
                    .cornerRadius(12)
                Spacer(minLength: 4)
            }
            .frame(height: 188)
        }
        .scrollIndicators(.hidden)
    }
}
