//
//  RoutineManager.swift
//  DailyFlowApp
//
//  Created by Federico Herrera on 25/06/2025.
//

import Foundation
import SwiftData
import UserNotifications


struct RoutineManager {
    let modelContext: ModelContext
    let routines: [Routine]
    
    let weekdays: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    func addTaskToRoutine(task: Task, day: String) {
        if let routine = routines.first(where: { $0.day == day }) {
            routine.tasks.append(task)
        } else {
            let newRoutine = Routine(day: day, tasks: [task])
            modelContext.insert(newRoutine)
        }
    }
    
    func updateTask(updatedTask: Task, day: String) {
        if let routine = routines.first(where: { $0.day == day }) {
            if let existingTask = routine.tasks.first(where: { $0.id == updatedTask.id }) {
                existingTask.title = updatedTask.title
                existingTask.taskDescription = updatedTask.taskDescription
                existingTask.startHour = updatedTask.startHour
                existingTask.endHour = updatedTask.endHour
            }
        }
    }
    
    func routineForThatDay(day: String) -> Routine? {
        routines.first { $0.tasks.count > 0 && $0.day == day }
    }
    
    func todaysRoutine() -> Routine? {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: "en_US")
        let today = formatter.string(from: Date())
        return routineForThatDay(day: today)
    }
    
    func deleteTask(_ task: Task, from day: String) {
        guard let routine = routineForThatDay(day: day) else { return }
        if let index = routine.tasks.firstIndex(where: { $0.id == task.id }) {
            routine.tasks.remove(at: index)
        }
    }
    
    func completedTasks(day: String) -> Int {
        guard let routine = routineForThatDay(day: day) else { return 0 }
        let now = Date()
        return routine.tasks.filter { $0.endHour <= now }.count
    }
    
    
    func scheduleNotification(for task: Task) {
        let content = UNMutableNotificationContent()
        content.title = "¡Es hora de empezar!"
        content.body = "Tarea: \(task.title)"
        content.sound = .default

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: task.startHour)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(
            identifier: task.id.uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    func cancelNotification(for task: Task) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task.id.uuidString])
    }
}
