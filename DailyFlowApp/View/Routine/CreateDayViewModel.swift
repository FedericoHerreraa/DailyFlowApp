//
//  CreateDayViewModel.swift
//  DailyFlowApp
//
//  Created by Federico Herrera on 25/06/2025.
//

import Foundation



final class CreateDayViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var startTime = Date()
    @Published var endTime = Date()
    @Published var showAlert: Bool = false
    @Published var textAlert: String = ""
    
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
