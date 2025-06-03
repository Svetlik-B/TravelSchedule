import SwiftUI

struct SearchField: View {
    @Binding var searchText: String
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(searchText.isEmpty ? Color.secondary : .primary)
                .padding(.leading, 8)
            TextField("Введите запрос", text: $searchText)
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .padding(.trailing, 8)
                        .tint(Color.secondary)
                }
            }
        }
        .frame(height: 36)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

#Preview("empty") {
    SearchField(searchText: .constant(""))
}
#Preview("with text") {
    SearchField(searchText: .constant("text"))
}
