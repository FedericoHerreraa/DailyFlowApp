//
//  HomeView.swift
//  DailyFlowApp
//
//  Created by Federico Herrera on 24/06/2025.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var languageManager: LanguageManager
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    @State private var showSheet = false
    @Environment(\.colorScheme) var colorScheme
    @State var showCalendarSheet = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                DailySummaryView()
                    .padding(.top, 15)
                
                ProgressHomeView()
                    .padding(.top, 7)
                
                CalendarHomeView()
                    .padding(.top, 10)
                
                TodayTasksView()
                    .padding(.top, 20)
                
                Spacer()
            }
            .onAppear {
                if !hasSeenOnboarding {
                    showSheet = true
                    hasSeenOnboarding = true
                }
            }
            .sheet(isPresented: $showSheet) {
                OnboardingView(isOnboardingActive: $showSheet)
                    .presentationCornerRadius(30)
            }
            .navigationTitle("Daily Flow")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showCalendarSheet.toggle()
                    } label: {
                        Image(systemName: "calendar")
                            .resizable()
                            .foregroundColor(colorScheme == .dark ? .white.opacity(0.8) : .black.opacity(0.8))
                            .scaledToFit()
                            .frame(height: 25)
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Text(languageManager.t("welcome_back"))
                        .foregroundColor(colorScheme == .dark ? .white.opacity(0.8) : .black.opacity(0.6))
                        .fontDesign(.rounded)
                }
            }
        }
        .sheet(isPresented: $showCalendarSheet) {
            MonthSheetCalendarView(showCalendarSheet: $showCalendarSheet)
                .presentationDetents([.medium])
                .presentationCornerRadius(30)
        }
    }
}




#Preview {
    HomeView()
        .environmentObject(AccentColor())
        .environmentObject(LanguageManager())
}
