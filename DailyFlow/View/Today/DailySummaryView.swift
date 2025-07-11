//
//  DailySummary.swift
//  DailyFlowApp
//
//  Created by Federico Herrera on 25/06/2025.
//

import SwiftUI
import SwiftData


struct DailySummaryView: View {
    @EnvironmentObject private var language: LanguageManager
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) var modelContext
    @Query private var routines: [Routine]
    
    var routineManager: RoutineManager {
        RoutineManager(modelContext: modelContext, routines: routines)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "hand.wave.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
                    .foregroundColor(colorScheme == .dark ? .white : .black.opacity(0.7))
                
                Text("\(language.t("home_summary_title")) \(greetingTime())")
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fontDesign(.rounded)
            }
            
            if let routine = routineManager.todaysRoutine() {
                HStack(spacing: 15) {
                    HStack(alignment: .center) {
                        Image(systemName: "list.bullet.clipboard")
                        Text("\(routine.tasks.count) \(language.t("home_summary_title").contains("Buenos") ? "tarea\(routine.tasks.count == 1 ? "" : "s") para hoy" : "task\(routine.tasks.count == 1 ? "" : "s") for today")")
                            .font(.subheadline)
                            .foregroundColor(colorScheme == .dark ? .white.opacity(0.7) : .black.opacity(0.7))
                            .fontDesign(.rounded)
                    }
                    
                    if let firstTask = routine.tasks.first,
                       let lastTask = routine.tasks.last {
                            HStack(alignment: .center) {
                                Image(systemName: "clock")
                                Text("\(formatted(firstTask.startHour)) - \(formatted(lastTask.endHour))")
                                    .font(.subheadline)
                                    .foregroundColor(colorScheme == .dark ? .white.opacity(0.7) : .black.opacity(0.7))
                                    .fontDesign(.rounded)
                            }
                    }
                }
            } else {
                Text(language.t("home_summary_description"))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fontDesign(.rounded)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(30)
        .padding(.horizontal)
    }
    
    func greetingTime() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12: return language.t("morning")
            case 12..<18: return language.t("afternoon")
            case 18..<22: return language.t("evening")
            default: return language.t("night")
        }
    }
    
    func formatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    func statusMessage(routine: Routine) -> String {
        let startTime = routine.tasks[0].startHour
        let endHour = routine.tasks[0].endHour
        let now = Date()
        if now < startTime {
            let diff = Calendar.current.dateComponents([.hour], from: now, to: startTime).hour ?? 0
            return "✅ All set! Starts in \(diff)h"
        } else if now > endHour {
            return "🎉 Done for today!"
        } else {
            return "🔄 In progress..."
        }
    }
}

#Preview {
    DailySummaryView()
        .environmentObject(LanguageManager())
}
