

import SwiftUI



struct MonthSheetCalendarView: View {
    @Binding var showCalendarSheet: Bool
    @EnvironmentObject private var accentColor: AccentColor

    var body: some View {
        NavigationStack {
            VStack(alignment: .trailing) {
                MonthCalendarView(title: false)
                    .padding(.top, 40)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button {
                                showCalendarSheet = false
                            } label: {
                                Text("Done")
                                    .bold()
                                    .foregroundColor(accentColor.color)
                                    .fontDesign(.rounded)
                            }
                        }
                    }
            }
        }
    }
}
