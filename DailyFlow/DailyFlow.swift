//
//  DailyFlowAppApp.swift
//  DailyFlowApp
//
//  Created by Federico Herrera on 24/06/2025.
//

import SwiftUI
import SwiftData
import UserNotifications


@main
struct DailyFlow: App {
    @StateObject var accentColor = AccentColor()
    @StateObject var languageManager = LanguageManager()
    @StateObject var selectedDayRoutine = SelectedDayRoutine()
    @AppStorage("notificationsEnabled") var notificationsEnabled: Bool = false
    @AppStorage("appColorScheme") private var appColorScheme: String = "system"
    @Environment(\.modelContext) var modelContext
    @Query private var routines: [Routine]
    
    var routineManager: RoutineManager {
        RoutineManager(modelContext: modelContext, routines: routines)
    }
    
    var body: some Scene {
        WindowGroup {
            TaskTabsView()
                .environmentObject(accentColor)
                .environmentObject(languageManager)
                .environmentObject(selectedDayRoutine)
                .preferredColorScheme(mapColorScheme(appColorScheme))
                .onAppear {
                    verifyDayAndUpdate()
                    requestNotificationPermissions()
                }
        }
        .modelContainer(for: [Routine.self, Task.self])
    }
    
    func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notifications: \(error.localizedDescription)")
            } else {
                print("Permission granted: \(granted)")
                notificationsEnabled = granted
            }
        }
    }
    
    func mapColorScheme(_ scheme: String) -> ColorScheme? {
        switch scheme {
            case "light": return .light
            case "dark": return .dark
            default: return nil
        }
    }
    
    func verifyDayAndUpdate() {
        let today = Date()
        let calendar = Calendar.current

        let isSunday = calendar.component(.weekday, from: today) == 1
        let lastUpdate = UserDefaults.standard.object(forKey: "lastUpdate") as? Date ?? .distantPast
        let alreadyRunThisSunday = calendar.isDate(lastUpdate, inSameDayAs: today)

        if isSunday && !alreadyRunThisSunday && calendar.component(.hour, from: today) >= 23 {
            var day = ""
            routineManager.routines.forEach { routine in
                day = routine.day
                routine.tasks.forEach { task in
                    if !task.repeatTask {
                        routineManager.deleteTask(task, from: day)
                    }
                }
            }

            UserDefaults.standard.set(today, forKey: "lastUpdate")
        }
    }
    
    
    
    
}
