

import SwiftUI

struct TaskTabsView: View {
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
                    Label("Home", systemImage: "house")
                }
                .tag(0)
            
            RoutineView()
                .tabItem {
                    Label("Routines", systemImage: "list.bullet.rectangle")
                }
                .tag(1)
            
            MonthCalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(3)
            
        }
        .accentColor(accentColor.color)
    }
}

#Preview {
    TaskTabsView()
}
