

import SwiftUI

struct TaskTabsView: View {
    @EnvironmentObject private var language: LanguageManager
    @EnvironmentObject private var accentColor: AccentColor
    @State var tabSelected: Int = 0
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .systemMaterial)
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView(selection: $tabSelected) {
            HomeView()
                .tabItem {
                    Label(language.t("home"), systemImage: "house")
                        .fontDesign(.rounded)
                }
                .tag(0)
            
            RoutineView()
                .tabItem {
                    Label(language.t("routines"), systemImage: "list.bullet.rectangle")
                        .fontDesign(.rounded)
                }
                .tag(1)

            
            SettingsView()
                .tabItem {
                    Label(language.t("settings"), systemImage: "gear")
                        .fontDesign(.rounded)
                }
                .tag(3)
            
        }
        .accentColor(accentColor.color)
    }
}

#Preview {
    TaskTabsView()
        .environmentObject(AccentColor())
}
