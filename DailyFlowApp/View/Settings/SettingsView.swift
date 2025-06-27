//
//  SettingsView.swift
//  DailyFlowApp
//
//  Created by Federico Herrera on 24/06/2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var accentColor: AccentColor
    @State var searchText: String = ""
    @State var lenguage: String = "es"
    
    let colorOptions = ["green", "blue", "pink", "orange"]

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section(header: Text("Select language")) {
                        Picker("Select language", selection: $lenguage) {
                            Text("Spanish").tag("es")
                            Text("English").tag("en")
                        }
                    }
                    
                    Section(header: Text("Select mode")) {
                        Text("Light")
                        Text("Dark")
                    }
                    
                    Section(header: Text("Select accent color")) {
                        Picker("Accent Color", selection: $accentColor.colorName) {
                            ForEach(colorOptions, id: \.self) { name in
                                HStack {
                                    Circle()
                                        .fill(colorFrom(name))
                                        .frame(width: 20, height: 20)
                                    Text(name.capitalized)
                                }.tag(name)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .searchable(text: $searchText, prompt: "Search settings")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Welcome back")
                        .foregroundColor(.black.opacity(0.6))
                }
            }
        }
    }

    private func colorFrom(_ name: String) -> Color {
        switch name {
            case "blue": return .blue
            case "green": return .green
            case "pink": return .pink
            case "orange": return .orange
            default: return .gray
        }
    }
}

#Preview {
    SettingsView()
}
