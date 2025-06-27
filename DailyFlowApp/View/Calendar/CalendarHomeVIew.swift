//
//  CalendarHomeVIew.swift
//  DailyFlowApp
//
//  Created by Federico Herrera on 25/06/2025.
//

import SwiftUI
import SwiftData


struct CalendarHomeView: View {
    @Environment(\.modelContext) var modelContext
    @Query private var routines: [Routine]
    
    var routineManager: RoutineManager {
        RoutineManager(modelContext: modelContext, routines: routines)
    }
    
    var body: some View {
        HStack(spacing: 7) {
            ForEach(routineManager.weekdays, id: \.self) { day in
                CalendarDayView(day: day)
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
    
    var body: some View {
        VStack(alignment: .center) {
            Circle()
                .fill(routineManager.routineForThatDay(day: day) != nil ? accentColor.color : Color.gray)
                .frame(width: 10, height: 10)
            
            Text(day.prefix(1).uppercased())
                .font(.headline)
                .bold()
        }
        .frame(width: 15)
        .padding(.horizontal, 15)
        .padding(.vertical, 15)
        .background(Color(.systemGray6)).cornerRadius(15)
    }
}

#Preview {
    CalendarHomeView()
}
