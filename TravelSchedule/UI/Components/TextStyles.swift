import SwiftUI

struct TextStyles: View {
    var body: some View {
        Text("Regular/12").r12
        Text("Regular/17").r17
        Text("Regular/20").r20
        Text("Bold/17").b17
        Text("Bold/24").b24
        Text("Bold/34").b34
    }
}

extension View {
    var r12: some View { self.font(.system(size: 12)) }
    var r17: some View { self.font(.system(size: 17)) }
    var r20: some View { self.font(.system(size: 20)) }
    var b17: some View { self.font(.system(size: 17, weight: .bold)) }
    var b24: some View { self.font(.system(size: 24, weight: .bold)) }
    var b34: some View { self.font(.system(size: 34, weight: .bold)) }
}

#Preview {
    TextStyles()
}
