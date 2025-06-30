//
//  CalendarView.swift
//  DailyFlowApp
//
//  Created by Federico Herrera on 26/06/2025.
//

import SwiftUI

struct MonthCalendarView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var accentColor: AccentColor
    let calendar = Calendar.current
    let month: Date = Date()
    let daysInWeek = 7
    var title: Bool = true

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
                        
                        Text("With routine")
                            .fontDesign(.rounded)
                    }
                    
                    HStack {
                        Circle()
                            .fill(.gray.opacity(colorScheme == .dark ? 1 : 0.3))
                            .frame(width: 13, height: 13)
                        
                        Text("Without routine")
                            .fontDesign(.rounded)
                    }
                    
                    Spacer()
                }
                .padding(.top)
                .padding(.horizontal)
                
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                        Text(day)
                            .font(.caption)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                    }
                    
                    ForEach(days, id: \.self) { date in
                        Text("\(calendar.component(.day, from: date))")
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(
                                calendar.isDate(date, inSameDayAs: Date()) ?
                                accentColor.color.opacity(0.2) : Color.clear
                            )
                            .clipShape(Circle())
                    }
                }
                .padding()
            }
            .navigationTitle(title ? "\(month, format: .dateTime.year().month())" : "")
            .toolbar {
                if title {
                    ToolbarItem(placement: .topBarLeading) {
                        Text("Welcome back")
                            .foregroundColor(colorScheme == .dark ? .white.opacity(0.6) : .black.opacity(0.6))
                            .fontDesign(.rounded)
                    }
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    MonthCalendarView(title: true)
        .environmentObject(AccentColor())
}
