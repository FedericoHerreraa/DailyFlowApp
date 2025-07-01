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
struct DailyFlowApp: App {
    @StateObject var accentColor = AccentColor()
    @StateObject var languageManager = LanguageManager()
    @AppStorage("notificationsEnabled") var notificationsEnabled: Bool = false
    @AppStorage("appColorScheme") private var appColorScheme: String = "system"
    
    var body: some Scene {
        WindowGroup {
            TaskTabsView()
                .environmentObject(accentColor)
                .environmentObject(languageManager)
                .preferredColorScheme(mapColorScheme(appColorScheme))
                .onAppear {
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
}
