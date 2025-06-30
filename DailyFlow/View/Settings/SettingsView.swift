//
//  SettingsView.swift
//  DailyFlowApp
//
//  Created by Federico Herrera on 24/06/2025.
//

import SwiftUI
import UserNotifications

struct SettingsView: View {
    @EnvironmentObject private var accentColor: AccentColor
    @AppStorage("notificationsEnabled") var notificationsEnabled: Bool = true
    @AppStorage("appColorScheme") private var appColorScheme: String = "system"
    @StateObject private var viewModel = SettingsViewModel()
    
    let colorOptions = ["green", "blue", "pink", "orange"]

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    if viewModel.searchText.isEmpty || "language".contains(viewModel.searchText.lowercased()) {
                        Section(header: Text("Select language")) {
                            HStack {
                                Image(systemName: "book")
                                Picker("Select language", selection: $viewModel.lenguage) {
                                    Text("Spanish").tag("es")
                                    Text("English").tag("en")
                                }
                                .fontDesign(.rounded)
                            }
                        }
                    }
                    
                    if viewModel.searchText.isEmpty || "mode".contains(viewModel.searchText.lowercased()) {
                        Section(header: Text("Select mode")) {
                            HStack {
                                Image(systemName: "sun.min")
                                Text("Light")
                                    .fontDesign(.rounded)
                                Spacer()
                                if appColorScheme == "light" {
                                    Image(systemName: "checkmark")
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                appColorScheme = "light"
                            }

                            HStack {
                                Image(systemName: "moon")
                                Text("Dark")
                                    .fontDesign(.rounded)
                                Spacer()
                                if appColorScheme == "dark" {
                                    Image(systemName: "checkmark")
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                appColorScheme = "dark"
                            }

                            HStack {
                                Image(systemName: "gear")
                                Text("Use system")
                                    .fontDesign(.rounded)
                                Spacer()
                                if appColorScheme == "system" {
                                    Image(systemName: "checkmark")
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                appColorScheme = "system"
                            }
                        }
                    }
                    
                    Section(header: Text("Notifications")) {
                        Toggle("Enable notifications", isOn: $notificationsEnabled)
                            .onChange(of: notificationsEnabled) {
                                print("🔁 Cambió toggle a: \(notificationsEnabled)")
                                
                                if notificationsEnabled {
                                    requestNotificationPermissions()
                                } else {
                                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                                    print("🔕 Notificaciones desactivadas")
                                }
                            }
                    }
                    
                    if viewModel.searchText.isEmpty || "accent color".contains(viewModel.searchText.lowercased()) {
                        Section(header: Text("Select accent color")) {
                            HStack {
                                Image(systemName: "paintpalette")
                                Picker("Accent Color", selection: $accentColor.colorName) {
                                    ForEach(colorOptions, id: \.self) { name in
                                        HStack {
                                            Circle()
                                                .fill(colorFrom(name))
                                                .frame(width: 20, height: 20)
                                            
                                            Text(name.capitalized)
                                                .fontDesign(.rounded)
                                        }.tag(name)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .searchable(text: $viewModel.searchText, prompt: "Search settings")
        }
        .alert("Enable Notifications", isPresented: $viewModel.showSettingsAlert) {
            Button("Go to Settings") {
                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSettings)
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("To enable notifications, allow them in Settings.")
        }
    }
    
    private func requestNotificationPermissions() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    DispatchQueue.main.async {
                        notificationsEnabled = granted
                        if granted {
                            print("✅ Permiso concedido")
                        } else {
                            print("❌ Usuario rechazó")
                        }
                    }
                }
            case .denied:
                DispatchQueue.main.async {
                    viewModel.showSettingsAlert = true
                }
            case .authorized, .provisional, .ephemeral:
                DispatchQueue.main.async {
                    notificationsEnabled = true
                }
            @unknown default:
                break
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
        .environmentObject(AccentColor())
}
