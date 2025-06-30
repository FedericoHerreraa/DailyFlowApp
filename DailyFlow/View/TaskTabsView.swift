

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
                        .fontDesign(.rounded)
                }
                .tag(0)
            
            RoutineView()
                .tabItem {
                    Label("Routines", systemImage: "list.bullet.rectangle")
                        .fontDesign(.rounded)
                }
                .tag(1)
            
            MonthCalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                        .fontDesign(.rounded)
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                        .fontDesign(.rounded)
                }
                .tag(3)
            
        }
        .accentColor(accentColor.color)
    }
}

#Preview {
    TaskTabsView()
}
