//
//  CalendarView.swift
//  DailyFlowApp
//
//  Created by Federico Herrera on 26/06/2025.
//

import SwiftUI
import SwiftData

struct MonthCalendarView: View {
    @EnvironmentObject private var language: LanguageManager
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var accentColor: AccentColor
    @Query private var routines: [Routine]
    
    let calendar = Calendar.current
    let month: Date = Date()
    let daysInWeek = 7
    
    var days: [Date] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: month),
            let firstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
            let lastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end - 1)
        else {
            return []
        }
        
        let daysRange = calendar.dateComponents([.day], from: firstWeek.start, to: lastWeek.end).day ?? 0
        return (0..<daysRange).compactMap {
            calendar.date(byAdding: .day, value: $0, to: firstWeek.start)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                let columns = Array(repeating: GridItem(.flexible()), count: daysInWeek)
                
                HStack(spacing: 20) {
                    HStack {
                        Circle()
                            .fill(accentColor.color)
                            .frame(width: 13, height: 13)
                        
                        Text(language.t("with_routine"))
                            .fontDesign(.rounded)
                    }
                    
                    HStack {
                        Circle()
                            .fill(.gray.opacity(colorScheme == .dark ? 1 : 0.3))
                            .frame(width: 13, height: 13)
                        
                        Text(language.t("without_routine"))
                            .fontDesign(.rounded)
                    }
                    
                    Spacer()
                }
                .padding(.top)
                .padding(.horizontal)
                
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(language.t("home_summary_title").contains("Buen") ? language.spanishWeekdays : language.englishWeekdays, id: \.self) { day in
                        Text(day.prefix(3))
                            .font(.caption)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                    }
                    
                    ForEach(days, id: \.self) { date in
                        VStack {
                            Text("\(calendar.component(.day, from: date))")
                                .frame(maxWidth: .infinity, minHeight: 40)
                                .background(
                                    calendar.isDate(date, inSameDayAs: Date()) ?
                                    accentColor.color.opacity(0.2) : Color.clear
                                )
                                .clipShape(Circle())
                            
                            if hasTask(on: date) {
                                Circle()
                                    .fill(accentColor.color)
                                    .frame(width: 6, height: 6)
                            } else {
                                Circle()
                                    .fill(.gray.opacity(colorScheme == .dark ? 1 : 0.3))
                                    .frame(width: 6, height: 6)
                            }
                        }
                    }
                }
                .padding()
            }
            
            Spacer()
        }
    }
    
    func hasTask(on date: Date) -> Bool {
        let weekday = calendar.component(.weekday, from: date)
        let weekdayName = calendar.weekdaySymbols[weekday - 1]
        
        let dateWeek = calendar.component(.weekOfYear, from: date)
        
        for routine in routines {
            if routine.day == weekdayName {
                for task in routine.tasks where task.repeatTask {
                    return true
                }
                
                for task in routine.tasks where !task.repeatTask {
                    let taskWeek = calendar.component(.weekOfYear, from: task.date)
                    
                    let isSameWeek = taskWeek == dateWeek
                    
                    if isSameWeek {
                        return true
                    }
                }
            }
        }

        return false
    }
}

#Preview {
    MonthCalendarView()
        .environmentObject(AccentColor())
}
