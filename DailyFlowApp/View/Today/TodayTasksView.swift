//
//  TodayTasksView.swift
//  DailyFlowApp
//
//  Created by Federico Herrera on 24/06/2025.
//

import SwiftUI
import SwiftData

struct TodayTasksView: View {
    @EnvironmentObject private var accentColor: AccentColor
    @Environment(\.modelContext) private var modelContext
    @Query private var routines: [Routine]
    
    @State var showSheetCreateTask: Bool = false
    
    var routineManager: RoutineManager {
        RoutineManager(modelContext: modelContext, routines: routines)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Today tasks")
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                Button {
                    showSheetCreateTask.toggle()
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .foregroundColor(accentColor.color)
                        .bold()
                        .scaledToFit()
                        .frame(height: 15)
                }
            }
            .padding(.horizontal, 25)
            
            if let routine = routineManager.todaysRoutine() {
                ForEach(routine.tasks.sorted(by: { $0.startHour < $1.startHour })) { task in
                    TaskView(task: task)
                }
            } else {
                NoRoutineView()
            }
            
        }
        .sheet(isPresented: $showSheetCreateTask) {
            NavigationStack {
                VStack(alignment: .trailing) {
                    CreateDayView(day: todaysDay())
                        .navigationTitle("Create fast routine")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .confirmationAction) {
                                Button {
                                    showSheetCreateTask = false
                                } label: {
                                    Text("Done")
                                        .foregroundColor(accentColor.color)
                                }
                            }
                        }
                }
            }
        }
    }
    
    func todaysDay() -> String {
        let today = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: "en_US")
        
        return formatter.string(from: today)
    }
}


struct TaskView: View {
    @EnvironmentObject private var accentColor: AccentColor
    let task: Task
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 12) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.black)
                    .frame(width: 4)
                    .frame(minHeight: 70)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(task.title)
                        .font(.title3)
                        .bold()
                    
                    Text(task.taskDescription)
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Text("\(formattedHour(task.startHour)) - \(formattedHour(task.endHour))")
                        .font(.headline)
                        .foregroundColor(.black.opacity(0.8))
                        .bold()
                }
            }
            .frame(height: calculateHeight(start: task.startHour, end: task.endHour))
            .frame(minHeight: 40)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(
                    colors: [accentColor.color.opacity(0.2), accentColor.color.opacity(0.02)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(accentColor.color.opacity(0.3), lineWidth: 1)
            )
        }
        .padding(.horizontal)
    }
    
    func formattedHour(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    func calculateHeight(start: Date, end: Date) -> CGFloat {
        let durationInMinutes = Calendar.current.dateComponents([.minute], from: start, to: end).minute ?? 0
        let duration = max(durationInMinutes, 1)
        let baseHeightPerMinute: CGFloat = 50.0 / 60.0
        return CGFloat(duration) * baseHeightPerMinute
    }
}


struct NoRoutineView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.exclamationmark")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.gray.opacity(0.6))
            
            Text("No tasks for today")
                .font(.title3)
                .bold()
            
            Text("Tap the + button to start planning your day.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 50)
    }
}

#Preview {
    TodayTasksView()
}
