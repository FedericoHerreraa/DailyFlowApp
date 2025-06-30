//
//  Characteristics.swift
//  DailyFlowApp
//
//  Created by Federico Herrera on 30/06/2025.
//

import Foundation


struct Characteristic: Identifiable {
    var id: UUID = UUID()
    var icon: String
    var title: String
    var description: String
}

let characteristics: [Characteristic] = [
    .init(icon: "plus.circle.fill", title: "Create tasks easily", description: "Add tasks with title, description and start/end times in seconds."),
    .init(icon: "calendar", title: "Smart calendar", description: "View your tasks organized by day and get a full monthly overview."),
    .init(icon: "bell.fill", title: "Custom reminders", description: "Receive local notifications when a task is about to start."),
    .init(icon: "paintpalette.fill", title: "Personalization", description: "Choose accent colors and switch between light and dark mode."),
    .init(icon: "chart.bar.fill", title: "Track your flow", description: "See your progress and completed tasks throughout the week.")
]
