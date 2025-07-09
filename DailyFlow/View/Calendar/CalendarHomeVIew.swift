//
//  CalendarHomeVIew.swift
//  DailyFlowApp
//
//  Created by Federico Herrera on 25/06/2025.
//

import SwiftUI
import SwiftData


//struct CalendarHomeView: View {
//    @EnvironmentObject private var language: LanguageManager
//    @Environment(\.modelContext) var modelContext
//    @Query private var routines: [Routine]
//    
//    var routineManager: RoutineManager {
//        RoutineManager(modelContext: modelContext, routines: routines)
//    }
//    
//    var body: some View {
//        HStack(spacing: 8) {
//            ForEach(language.t("home").contains("Home") ? language.englishWeekdays : language.spanishWeekdays, id: \.self) { day in
//                CalendarDayView(day: day)
//            }
//        }
//    }
//}
//
//
//struct CalendarDayView: View {
//    @EnvironmentObject private var accentColor: AccentColor
//    @Environment(\.modelContext) var modelContext
//    @Query private var routines: [Routine]
//    
//    var routineManager: RoutineManager {
//        RoutineManager(modelContext: modelContext, routines: routines)
//    }
//    
//    let day: String
//    
//    var body: some View {
//        VStack(alignment: .center) {
//            Circle()
//                .fill(routineManager.routineForThatDay(day: day) != nil ? accentColor.color : Color.gray)
//                .frame(width: 10, height: 10)
//            
//            Text(day.prefix(1).uppercased())
//                .font(.headline)
//                .bold()
//                .fontDesign(.rounded)
//        }
//        .frame(width: 15)
//        .padding(.horizontal, 15)
//        .padding(.vertical, 15)
//        .background(Color(.systemGray6)).cornerRadius(30)
//    }
//}

struct CalendarHomeView: View {
    @EnvironmentObject private var language: LanguageManager
    @Environment(\.modelContext) var modelContext
    @Query private var routines: [Routine]
    @State var selectedTab: String = ""

    var routineManager: RoutineManager {
        RoutineManager(modelContext: modelContext, routines: routines)
    }

    var weekdays: [String] {
        language.t("home").contains("Home") ? language.englishWeekdays : language.spanishWeekdays
    }
    
    var defaultDay: String {
        language.t("home").contains("Home") ? "Monday" : "Lunes"
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(weekdays, id: \.self) { day in
                    CalendarDayView(day: day, selectedTab: $selectedTab)
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            if selectedTab.isEmpty {
                selectedTab = defaultDay
            }
        }
    }
}


struct CalendarDayView: View {
    @EnvironmentObject private var accentColor: AccentColor
    @Environment(\.modelContext) var modelContext
    @Query private var routines: [Routine]

    var routineManager: RoutineManager {
        RoutineManager(modelContext: modelContext, routines: routines)
    }

    let day: String
    @Binding var selectedTab: String

    var isSelected: Bool {
        selectedTab == day
    }

    var body: some View {
        HStack(spacing: isSelected ? 8 : 4) {
            Circle()
                .fill(routineManager.routineForThatDay(day: day) != nil ? accentColor.color : .gray)
                .frame(width: 10, height: 10)

            if isSelected {
                Text(day)
                    .font(.system(size: 13))
                    .bold()
                    .fontDesign(.rounded)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .transition(.opacity.combined(with: .scale))
            } else {
                Text(day.prefix(1).uppercased())
                    .font(.system(size: 13))
                    .bold()
                    .fontDesign(.rounded)
            }
        }
        .frame(width: isSelected ? 80 : 35)
        .padding(.horizontal, 8)
        .padding(.vertical, 10)
        .background(isSelected ? accentColor.color.opacity(0.2) : Color(.systemGray6))
        .cornerRadius(30)
        .onTapGesture {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                selectedTab = day
            }
        }
    }
}

#Preview {
    CalendarHomeView()
        .environmentObject(LanguageManager())
        .environmentObject(AccentColor())
}
