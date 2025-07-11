//
//  SelectedDayRoutine.swift
//  DailyFlowApp
//
//  Created by Federico Herrera on 10/07/2025.
//

import Foundation



@MainActor
final class SelectedDayRoutine: ObservableObject {
    @Published var selectedDay: String = ""
}
