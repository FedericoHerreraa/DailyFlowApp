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
    @EnvironmentObject private var language: LanguageManager
    @AppStorage("notificationsEnabled") var notificationsEnabled: Bool = true
    @AppStorage("appColorScheme") private var appColorScheme: String = "system"
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    if viewModel.searchText.isEmpty || "language".contains(viewModel.searchText.lowercased()) {
                        Section(header: Text(language.t("language"))) {
                            HStack {
                                Image(systemName: "book")
                                Picker(language.t("select_language"), selection: $language.selectedLanguage) {
                                    Text("Español").tag("es")
                                    Text("English").tag("en")
                                }
                                .fontDesign(.rounded)
                            }
                        }
                    }
                    
                    if viewModel.searchText.isEmpty || "mode".contains(viewModel.searchText.lowercased()) {
                        Section(header: Text(language.t("select_mode"))) {
                            HStack {
                                Image(systemName: "sun.min")
                                Text(language.t("light"))
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
                                Text(language.t("dark"))
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
                                Text(language.t("use_system"))
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
                    
                    if viewModel.searchText.isEmpty || "notifications".contains(viewModel.searchText.lowercased()) {
                        Section(header: Text(language.t("notifications"))) {
                            Toggle(language.t("enable_notifications"), isOn: $notificationsEnabled)
                                .onChange(of: notificationsEnabled) {
                                    if notificationsEnabled {
                                        requestNotificationPermissions()
                                    } else {
                                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                                        print("🔕 Notificaciones desactivadas")
                                    }
                                }
                        }                        
                    }
                    
                    if viewModel.searchText.isEmpty || "accent color".contains(viewModel.searchText.lowercased()) {
                        Section(header: Text(language.t("select_accent_color"))) {
                            HStack {
                                Image(systemName: "paintpalette")
                                Picker(language.t("accent_color"), selection: $accentColor.colorName) {
                                    ForEach(viewModel.colorOptions, id: \.self) { name in
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
            .navigationTitle(language.t("settings"))
            .searchable(text: $viewModel.searchText, prompt: language.t("search_settings"))
        }
        .alert(language.t("enable_notifications"), isPresented: $viewModel.showSettingsAlert) {
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
