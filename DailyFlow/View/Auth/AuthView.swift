//
//  AuthView.swift
//  DailyFlowApp
//
//  Created by Federico Herrera on 10/07/2025.
//

import SwiftUI

struct AuthView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Button("Continuar con Google") {
                    // Google Sign-In
                }
                .buttonStyle(.borderedProminent)
                
                Button("Continuar con Apple") {
                    // Apple Sign-In
                }
                .buttonStyle(.bordered)
                
                NavigationLink("Iniciar con Email y Password", destination: LoginView())
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(colorScheme == .dark ? .white : .black)
        }
        
    }
}

#Preview {
    AuthView()
}
