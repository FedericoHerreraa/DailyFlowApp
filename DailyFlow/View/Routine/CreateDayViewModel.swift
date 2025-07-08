//
//  CreateDayViewModel.swift
//  DailyFlowApp
//
//  Created by Federico Herrera on 25/06/2025.
//

import Foundation



final class CreateDayViewModel: ObservableObject {
    @Published var taskId: UUID = UUID()
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var startTime: Date = Date()
    @Published var endTime: Date = Date()
    @Published var showAlert: Bool = false
    @Published var textAlert: String = ""
    @Published var updateTask: Bool = false
    @Published var repeatTask: Bool = false
    
    func clear() {
        title = ""
        description = ""
    }
    
    func formattedHour(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    func validateForm() -> String? {
        if title.isEmpty || description.isEmpty {
            return "You have to fill all the fields"
        } else if startTime >= endTime {
            return "Start time can't be greater than end time"
        } else if startTime == endTime {
            return "Start time can't be equal to end time"
        }
        
        return nil
    }
}
