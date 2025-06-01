//
//  UserAgreementView.swift
//  TravelSchedule
//
//  Created by Svetlana Bochkareva on 01.06.2025.
//

import SwiftUI

struct UserAgreementView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack {
            Text("Пользовательское соглашение")
            Button("Close") {
                dismiss()
            }
        }
        
    }
}

#Preview {
    UserAgreementView()
}
