//
//  HomeView.swift
//  DailyFlowApp
//
//  Created by Federico Herrera on 24/06/2025.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var showCalendarSheet = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                DailySummaryView()
                    .padding(.top, 15)
                
                CalendarHomeView()
                    .padding(.top, 15)
                
                TodayTasksView()
                    .padding(.top, 20)
                
                ProgressHomeView()
                    .padding(.top, 20)
                
                Spacer()
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
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        print("hola")
                    } label: {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .foregroundColor(colorScheme == .dark ? .white.opacity(0.8) : .black.opacity(0.8))
                            .scaledToFit()
                            .frame(height: 25)
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Text("Welcome back")
                        .foregroundColor(colorScheme == .dark ? .white.opacity(0.8) : .black.opacity(0.6))
                }
            }
        }
        .sheet(isPresented: $showCalendarSheet) {
            MonthSheetCalendarView(showCalendarSheet: $showCalendarSheet)
        }
    }
}




#Preview {
    HomeView()
}
