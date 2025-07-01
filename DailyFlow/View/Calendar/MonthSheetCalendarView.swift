

import SwiftUI



struct MonthSheetCalendarView: View {
    @Binding var showCalendarSheet: Bool
    @EnvironmentObject private var accentColor: AccentColor

    var body: some View {
        NavigationStack {
            VStack(alignment: .trailing) {
                MonthCalendarView()
                    .padding(.top, 20)
            }
        }
    }
}
