//
//  SettingsViewModel.swift
//  DailyFlowApp
//
//  Created by Federico Herrera on 30/06/2025.
//

import Foundation
import UserNotifications
import SwiftUI

final class SettingsViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var showSettingsAlert = false
    @Published var lenguage: String = "es"
    @Published var colorOptions = ["green", "blue", "pink", "orange"]
}
