//
//  UserNotifications.swift
//  DailyFlowApp
//
//  Created by Federico Herrera on 30/06/2025.
//

import Foundation
import UserNotifications


final class UserNotifications {
    func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notifications: \(error.localizedDescription)")
            } else {
                print("Permission granted: \(granted)")
                UserDefaults.standard.set(granted, forKey: "notificationsEnabled")
            }
        }
    }
}
