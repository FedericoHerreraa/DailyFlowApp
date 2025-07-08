//
//  Task.swift
//  DailyFlowApp
//
//  Created by Federico Herrera on 24/06/2025.
//

import Foundation
import SwiftData


@Model
class Task: Identifiable {
    var id: UUID
    var title: String
    var taskDescription: String
    var startHour: Date
    var endHour: Date
//    var repeatTask: Bool
    
    init(id: UUID = UUID(), title: String, description: String, startHour: Date, endHour: Date) {
        self.id = id
        self.title = title
        self.taskDescription = description
        self.startHour = startHour
        self.endHour = endHour
//        self.repeatTask = repeatTask
    }
}


