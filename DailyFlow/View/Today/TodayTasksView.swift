//
//  TodayTasksView.swift
//  DailyFlowApp
//
//  Created by Federico Herrera on 24/06/2025.
//

import SwiftUI
import SwiftData

struct TodayTasksView: View {
    @EnvironmentObject private var languageManager: LanguageManager
    @EnvironmentObject private var accentColor: AccentColor
    @EnvironmentObject private var selectedDay: SelectedDayRoutine
    @Environment(\.modelContext) private var modelContext
    @Query private var routines: [Routine]
    
    @State var showSheetCreateTask: Bool = false
    
    var routineManager: RoutineManager {
        RoutineManager(modelContext: modelContext, routines: routines)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                HStack {
                    Text(languageManager.t("today_task_title"))
                        .font(.title2)
                        .bold()
                        .fontDesign(.rounded)
                    
                    Text(selectedDay.selectedDay)
                        .font(.title2)
                        .bold()
                        .fontDesign(.rounded)
                        .padding(.leading, -4)
                }
                
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
            
            Group {
                if let routine = routineManager.routineForThatDay(day: selectedDay.selectedDay) {
                    ForEach(routine.tasks.sorted(by: { $0.startHour < $1.startHour })) { task in
                        TaskView(task: task)
                    }
                } else {
                    NoRoutineView()
                }
            }
        }
        .sheet(isPresented: $showSheetCreateTask) {
            NavigationStack {
                VStack(alignment: .trailing) {
                    CreateDayView(day: routineManager.dayTranslation[selectedDay.selectedDay] ?? selectedDay.selectedDay)
                        .navigationTitle(languageManager.t("create_fast_routine"))
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .confirmationAction) {
                                Button {
                                    showSheetCreateTask = false
                                } label: {
                                    Text(languageManager.t("close_modal_button"))
                                        .foregroundColor(accentColor.color)
                                        .fontDesign(.rounded)
                                }
                            }
                        }
                }
            }
            .presentationCornerRadius(30)
        }
    }
}


struct TaskView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var accentColor: AccentColor
    let task: Task
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 12) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(colorScheme == .dark ? Color.white : Color.black)
                    .frame(width: 4)
                    .frame(minHeight: 70)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(task.title)
                        .font(.title3)
                        .bold()
                        .fontDesign(.rounded)
                    
                    Text(task.taskDescription)
                        .font(.headline)
                        .foregroundColor(colorScheme == .dark ? .white.opacity(0.7) : .black.opacity(0.7))
                        .fontDesign(.rounded)
                    
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(colorScheme == .dark ? .white.opacity(0.7) : .black.opacity(0.7))
                        
                        Text("\(formattedHour(task.startHour))hs - \(formattedHour(task.endHour))hs")
                            .font(.subheadline)
                            .foregroundColor(colorScheme == .dark ? .white.opacity(0.8) : .black.opacity(0.8))
                            .bold()
                            .fontDesign(.rounded)
                    }
                }
            }
            .frame(height: calculateHeight(start: task.startHour, end: task.endHour))
            .frame(minHeight: 40)
            .padding()
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(
                    colors: [accentColor.color.opacity(colorScheme == .dark ? 0.5 : 0.3), accentColor.color.opacity(colorScheme == .dark ? 0.05 : 0.05)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(26)
            .overlay(
                RoundedRectangle(cornerRadius: 26)
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
    @EnvironmentObject private var languageManager: LanguageManager
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.exclamationmark")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.gray.opacity(0.6))
            
            Text(languageManager.t("no_task_title"))
                .font(.title3)
                .bold()
                .fontDesign(.rounded)
            
            Text(languageManager.t("no_task_description"))
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .fontDesign(.rounded)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 50)
    }
}

#Preview {
    TodayTasksView()
        .environmentObject(AccentColor())
}
