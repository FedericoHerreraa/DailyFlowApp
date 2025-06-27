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
struct DailyFlowAppApp: App {
    @StateObject var accentColor = AccentColor()
    
    var body: some Scene {
        WindowGroup {
            TaskTabsView()
                .environmentObject(accentColor)
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
            }
        }
    }
}
