//
//  RoutineViewModel.swift
//  DailyFlowApp
//
//  Created by Federico Herrera on 26/06/2025.
//

import Foundation


final class RoutineViewModel: ObservableObject {
    @Published var showCalendarSheet: Bool = false
    @Published var filterByCreated: Bool = false
    @Published var filterByNoCreated: Bool = false
}
