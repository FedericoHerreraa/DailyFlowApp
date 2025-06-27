

import Foundation
import SwiftUI



@MainActor
final class AccentColor: ObservableObject {
    @Published var colorName: String {
        didSet {
            UserDefaults.standard.set(colorName, forKey: "accentColor")
        }
    }

    var color: Color {
        switch colorName {
            case "blue": return .blue
            case "green": return .green
            case "pink": return .pink
            case "orange": return .orange
            default: return .green
        }
    }

    init() {
        self.colorName = UserDefaults.standard.string(forKey: "accentColor") ?? "green"
    }
}
