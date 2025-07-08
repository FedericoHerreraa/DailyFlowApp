//
//  ProgressHomeView.swift
//  DailyFlowApp
//
//  Created by Federico Herrera on 25/06/2025.
//

import SwiftUI
import SwiftData

struct ProgressHomeView: View {
    @EnvironmentObject private var languageManager: LanguageManager
    @EnvironmentObject private var accentColor: AccentColor
    @Environment(\.modelContext) var modelContext
    @Query private var routines: [Routine]
    @State private var currentDate = Date()
    
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    var routineManager: RoutineManager {
        RoutineManager(modelContext: modelContext, routines: routines)
    }

    var today: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: currentDate)
    }

    var progress: Double {
        guard let routine = routineManager.routineForThatDay(day: today),
              !routine.tasks.isEmpty else { return 0 }
        
        let completed = routineManager.completedTasks(day: today)
        return Double(completed) / Double(routine.tasks.count)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(languageManager.t("progress_title"))
                .font(.title3)

            if let routine = routineManager.routineForThatDay(day: today) {
                ProgressView(value: progress)
                    .tint(accentColor.color)
                    .scaleEffect(x: 1, y: 2, anchor: .center)
                    .animation(.easeOut(duration: 0.3), value: progress)

                HStack {
                    HStack {
                        Image(systemName: "checkmark.square.fill")
                            .foregroundColor(accentColor.color)
                        
                        Text("\(Int(progress * 100))% \(languageManager.t("progress_title").contains("Progreso") ? "completado" : "completed")")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    Text("\(routineManager.completedTasks(day: today))/\(routine.tasks.count) \(languageManager.t("progress_title").contains("Progreso") ? "tareas" : "tasks")")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            } else {
                Text(languageManager.t("no_progress_description"))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(30)
        .padding(.horizontal)
        .onReceive(timer) { input in
            currentDate = input 
        }
    }
    
}

#Preview {
    ProgressHomeView()
}
