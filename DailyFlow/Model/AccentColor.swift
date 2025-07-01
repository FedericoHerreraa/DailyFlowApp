

import Foundation
import SwiftUI



@MainActor
final class AccentColor: ObservableObject {
    @Published var colorName: String {
        didSet {
            UserDefaults.standard.set(colorName, forKey: "accentColor")
        }
    }
    
    let language = UserDefaults.standard.string(forKey: "selectedLanguage")

    var color: Color {
        let normalizedColorName: String
        if language == "es" {
            switch colorName {
                case "azul": normalizedColorName = "blue"
                case "verde": normalizedColorName = "green"
                case "rosa": normalizedColorName = "pink"
                case "naranja": normalizedColorName = "orange"
                default: normalizedColorName = colorName
            }
        } else {
            normalizedColorName = colorName
        }

        switch normalizedColorName {
            case "blue": return .blue
            case "green": return .green
            case "pink": return .pink
            case "orange": return .orange
            default: return .green
        }
    }

    init() {
        self.colorName = UserDefaults.standard.string(forKey: "accentColor") ?? language == "es" ? "verde" : "green"
    }
}
