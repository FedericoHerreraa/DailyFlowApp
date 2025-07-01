//
//  LanguageManager.swift
//  DailyFlowApp
//
//  Created by Federico Herrera on 01/07/2025.
//

import Foundation

final class LanguageManager: ObservableObject {
    @Published var selectedLanguage: String {
        didSet {
            UserDefaults.standard.set(selectedLanguage, forKey: "selectedLanguage")
        }
    }
    
    @Published var englishWeekdays: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    @Published var spanishWeekdays: [String] = ["Lunes", "Martes", "Miercoles", "Jueves", "Viernes", "Sabado", "Domingo"]

    init() {
        self.selectedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "es"
    }

    func t(_ key: String) -> String {
        let selected = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en"
        guard let path = Bundle.main.path(forResource: selected, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return NSLocalizedString(key, comment: "")
        }
        return NSLocalizedString(key, bundle: bundle, comment: "")
    }
}
