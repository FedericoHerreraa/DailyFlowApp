//
//  Routine.swift
//  DailyFlowApp
//
//  Created by Federico Herrera on 24/06/2025.
//

import Foundation
import SwiftData



@Model
class Routine {
    var id: UUID
    var day: String
    var tasks: [Task]

    init(id: UUID = UUID(), day: String, tasks: [Task] = []) {
        self.id = id
        self.day = day
        self.tasks = tasks
    }
}

