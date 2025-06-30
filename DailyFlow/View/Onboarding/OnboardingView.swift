//
//  OnboardingView.swift
//  DailyFlowApp
//
//  Created by Federico Herrera on 30/06/2025.
//

import SwiftUI



struct OnboardingView: View {
    @Binding var isOnboardingActive: Bool
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Welcome to")
                    Text("DailyFlow")
                        .foregroundColor(.green)
                }
                .font(.system(size: 40))
                .bold()
                .padding(.vertical, 40)
                .fontDesign(.rounded)
                
                VStack(alignment: .leading, spacing: 40) {
                    ForEach(characteristics) { item in
                        HStack(spacing: 20) {
                            Image(systemName: item.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30)
                                .foregroundColor(.green)
                            
                            VStack(alignment: .leading) {
                                Text(item.title)
                                    .bold()
                                    .font(.title3)
                                
                                Text(item.description)
                                    .foregroundColor(.gray)
                            }
                            .fontDesign(.rounded)
                        }
                    }
                }
                .padding(.horizontal, 50)
            }
            .scrollIndicators(.hidden)
            
            
            VStack(alignment: .center) {
                Image(systemName: "person.2.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                    .foregroundColor(.green)
                
                Text("Your data is stored securely in DailyFlow")
                    .foregroundColor(.gray)
                    .fontDesign(.rounded)
                
                Button {
                    isOnboardingActive = false
                } label: {
                    Text("Continue")
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .fontDesign(.rounded)
                }
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(.green)
                .cornerRadius(10)

            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(isOnboardingActive: .constant(true))
}
