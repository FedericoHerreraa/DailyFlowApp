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
    let daysEnglish = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    let daysSpanish = ["Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado"]
    let dayTranslation: [String: String] = [
        "Lunes": "Monday",
        "Martes": "Tuesday",
        "Miercoles": "Wednesday",
        "Jueves": "Thursday",
        "Viernes": "Friday",
        "Sabado": "Saturday",
        "Domingo": "Sunday"
    ]
    let language = UserDefaults.standard.string(forKey: "selectedLanguage")
    
    func addTaskToRoutine(task: Task, day: String) {
        scheduleNotification(for: task)
        if let routine = routines.first(where: { $0.day == day }) {
            routine.tasks.append(task)
        } else {
            let newRoutine = Routine(day: day, tasks: [task])
            modelContext.insert(newRoutine)
        }
    }
    
    func updateTask(updatedTask: Task, day: String) {
        cancelNotification(for: "\(updatedTask.id.uuidString)-start")
        cancelNotification(for: "\(updatedTask.id.uuidString)-end")
        scheduleNotification(for: updatedTask)
        if let routine = routines.first(where: { $0.day == day }) {
            if let existingTask = routine.tasks.first(where: { $0.id == updatedTask.id }) {
                existingTask.title = updatedTask.title
                existingTask.taskDescription = updatedTask.taskDescription
                existingTask.startHour = updatedTask.startHour
                existingTask.endHour = updatedTask.endHour
                existingTask.repeatTask = updatedTask.repeatTask
            }
        }
    }
    
    func todaysDay() -> String {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: "es_ES")
        let day = formatter.string(from: today).capitalized
        
        var newDay = ""
        if language == "en" {
            newDay = dayTranslation[day] ?? day
        } else {
            newDay = day
        }
        
        return newDay
    }
    
    func routineForThatDay(day: String) -> Routine? {
        let translatedDay = dayTranslation[day] ?? day
        return routines.first { $0.tasks.count > 0 && $0.day == translatedDay }
    }
    
    func todaysRoutine() -> Routine? {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: "en_US")
        let today = formatter.string(from: Date())
        return routineForThatDay(day: today)
    }
    
    func deleteTask(_ task: Task, from day: String) {
        cancelNotification(for: "\(task.id.uuidString)-start")
        cancelNotification(for: "\(task.id.uuidString)-end")
        guard let routine = routineForThatDay(day: day) else { return }
        if let index = routine.tasks.firstIndex(where: { $0.id == task.id }) {
            routine.tasks.remove(at: index)
            try? modelContext.save()
        }
    }
    
    func completedTasks(day: String) -> Int {
        guard let routine = routineForThatDay(day: day) else { return 0 }
        let now = Date()
        return routine.tasks.filter { $0.endHour <= now }.count
    }
    
    
    func scheduleNotification(for task: Task) {
        let notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        print(notificationsEnabled)
        guard notificationsEnabled else {
            print("🔕 Notificaciones desactivadas")
            return
        }
                
        // Notification at the beggining of the task
        let contentStart = UNMutableNotificationContent()
        contentStart.title = language == "es" ? "¡Es hora de empezar!" : "It's time to start!"
        contentStart.body = language == "es" ? "Tarea: \(task.title)" : "Task: \(task.title)"
        contentStart.sound = .default
        
        // Notification at the end of the task
        let contentEnd = UNMutableNotificationContent()
        contentEnd.title = language == "es" ? "¡Ya terminaste!" : "Hey, it's done!"
        contentEnd.body = language == "es" ? "Tarea: \(task.title)" : "Task: \(task.title)"
        contentEnd.sound = .default
        
        let triggerDateStart = Calendar.current.dateComponents([.hour, .minute], from: task.startHour)
        
        let triggerDateEnd = Calendar.current.dateComponents([.hour, .minute], from: task.endHour)

        let triggerStart = UNCalendarNotificationTrigger(dateMatching: triggerDateStart, repeats: false)
        let triggerEnd = UNCalendarNotificationTrigger(dateMatching: triggerDateEnd, repeats: false)

        let requestStart = UNNotificationRequest(
            identifier: "\(task.id.uuidString)-start",
            content: contentStart,
            trigger: triggerStart
        )

        let requestEnd = UNNotificationRequest(
            identifier: "\(task.id.uuidString)-end",
            content: contentEnd,
            trigger: triggerEnd
        )

        UNUserNotificationCenter.current().add(requestStart) { error in
            if let error = error {
                print("❌ Error al agendar: \(error.localizedDescription)")
            } else {
                print("✅ Notificación inicio agendada para: \(triggerDateStart.hour ?? 0):\(triggerDateStart.minute ?? 0)")
            }
        }
        
        UNUserNotificationCenter.current().add(requestEnd) { error in
            if let error = error {
                print("❌ Error al agendar: \(error.localizedDescription)")
            } else {
                print("✅ Notificación final agendada para: \(triggerDateEnd.hour ?? 0):\(triggerDateEnd.minute ?? 0)")
            }
        }
    }
    
    func cancelNotification(for taskId: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [taskId])
    }
}
