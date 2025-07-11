//
//  LoginView.swift
//  DailyFlowApp
//
//  Created by Federico Herrera on 10/07/2025.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var auth: AuthViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var username = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 20) {
            TextField("Usuario", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            SecureField("Contraseña", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Iniciar sesión") {
                // Login func
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(colorScheme == .dark ? .white : .black)
    }
}

#Preview {
    LoginView()
}
