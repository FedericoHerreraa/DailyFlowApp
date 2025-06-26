//
//  ProgressHomeView.swift
//  DailyFlowApp
//
//  Created by Federico Herrera on 25/06/2025.
//

import SwiftUI
import SwiftData

struct ProgressHomeView: View {
    @Environment(\.modelContext) var modelContext
    @Query private var routines: [Routine]
    
    var routineManager: RoutineManager {
        RoutineManager(modelContext: modelContext, routines: routines)
    }

    var today: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: Date())
    }

    var progress: Double {
        guard let routine = routineManager.routineForThatDay(day: today),
              !routine.tasks.isEmpty else { return 0 }
        
        let completed = routineManager.completedTasks(day: today)
        return Double(completed) / Double(routine.tasks.count)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Day Progress")
                .font(.title3)

            if let routine = routineManager.routineForThatDay(day: today) {
                ProgressView(value: progress)
                    .tint(.green)
                    .scaleEffect(x: 1, y: 2, anchor: .center)
                    .animation(.easeOut(duration: 0.3), value: progress)

                HStack {
                    HStack {
                        Image(systemName: "checkmark.square.fill")
                            .foregroundColor(.green)
                        
                        Text("\(Int(progress * 100))% completed")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    Text("\(routineManager.completedTasks(day: today))/\(routine.tasks.count) tasks")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            } else {
                Text("There's nothing set yet, do it now!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

#Preview {
    ProgressHomeView()
}
