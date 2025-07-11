//
//  RoutinesView.swift
//  DailyFlowApp
//
//  Created by Federico Herrera on 24/06/2025.
//

import SwiftUI
import SwiftData


struct RoutineView: View {
    @EnvironmentObject private var language: LanguageManager
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var accentColor: AccentColor
    @Environment(\.modelContext) var modelContext
    @Query private var routines: [Routine]
    
    var routineManager: RoutineManager {
        RoutineManager(modelContext: modelContext, routines: routines)
    }
    
    @StateObject private var viewModel = RoutineViewModel()
    
    var body: some View {
        NavigationStack {
            VStack  {
                HStack(spacing: 10) {
                    Button {
                        if viewModel.filterByNoCreated {
                            viewModel.filterByNoCreated.toggle()
                        }
                        viewModel.filterByCreated.toggle()
                    } label: {
                        HStack {
                            Circle()
                                .fill(accentColor.color)
                                .frame(width: 13, height: 13)
                            
                            Text(language.t("with_routine"))
                                .font(.system(size: 13))
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .padding(.leading, 2)
                                .fontDesign(.rounded)
                            
                            Image(systemName: viewModel.filterByCreated ? "minus" : "plus")
                                .foregroundColor(accentColor.color)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(viewModel.filterByCreated ? accentColor.color.opacity(0.1) : Color(.systemGray6))
                        .clipShape(Capsule())
                        .overlay {
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(viewModel.filterByCreated ? accentColor.color : Color(.systemGray6), lineWidth: 1)
                        }
                    }
                    
                    
                    Button {
                        if viewModel.filterByCreated {
                            viewModel.filterByCreated.toggle()
                        }
                        viewModel.filterByNoCreated.toggle()
                    } label: {
                        HStack {
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 13, height: 13)
                            
                            Text(language.t("without_routine"))
                                .font(.system(size: 13))
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .padding(.leading, 2)
                                .fontDesign(.rounded)
                            
                            Image(systemName: viewModel.filterByNoCreated ? "minus" : "plus")
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(viewModel.filterByNoCreated ? accentColor.color.opacity(0.1) : Color(.systemGray6))
                        .clipShape(Capsule())
                        .overlay {
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(viewModel.filterByNoCreated ? accentColor.color : Color(.systemGray6), lineWidth: 1)
                        }
                    }

                    Spacer()
                }
                .padding(.horizontal)
                
                let weekdays = language.t("home").contains("Home") ? language.englishWeekdays : language.spanishWeekdays
                
                let filteredDays = weekdays.filter {
                    viewModel.searchText.isEmpty || $0.lowercased().contains(viewModel.searchText.lowercased())
                }
                
                List {
                    ForEach(filteredDays, id: \.self) { day in
                        RoutineItemView(day: day, routineManager: routineManager, viewModel: viewModel)
                    }
                }
                .listStyle(.plain)
                .padding(.top, 20)
                .padding(.horizontal, 5)
                
            }
            .navigationTitle(language.t("create_your_routine"))
            .searchable(text: $viewModel.searchText, prompt: language.t("search_input"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.showCalendarSheet.toggle()
                    } label: {
                        Image(systemName: "calendar")
                            .resizable()
                            .foregroundColor(colorScheme == .dark ? .white.opacity(0.8) : .black.opacity(0.8))
                            .scaledToFit()
                            .frame(height: 25)
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Text(language.t("welcome_back"))
                        .foregroundColor(colorScheme == .dark ? .white.opacity(0.6) : .black.opacity(0.6))
                        .fontDesign(.rounded)
                }
            }
        }
        .sheet(isPresented: $viewModel.showCalendarSheet) {
            MonthSheetCalendarView(showCalendarSheet: $viewModel.showCalendarSheet)
                .presentationDetents([.medium])
                .presentationCornerRadius(30)
        }
    }
}


struct RoutineItemView: View {
    @EnvironmentObject private var language: LanguageManager
    @EnvironmentObject private var accentColor: AccentColor
    let day: String
    let routineManager: RoutineManager
    @ObservedObject var viewModel: RoutineViewModel
    
    var body: some View {
        if viewModel.filterByCreated && routineManager.routineForThatDay(day: day) == nil {
            EmptyView()
        } else if viewModel.filterByNoCreated && routineManager.routineForThatDay(day: day) != nil {
            EmptyView()
        } else {
            NavigationLink(destination: CreateDayView(day: day)) {
                VStack(alignment: .leading) {
                    HStack {
                        Circle()
                            .fill(routineManager.routineForThatDay(day: day) != nil ? accentColor.color : Color.gray)
                            .frame(width: 13, height: 13)
                        
                        Text(day)
                            .font(.title3)
                    }
                    Text(routineManager.routineForThatDay(day: day) != nil ? language.t("have_routine") : language.t("do_not_have_routine"))
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

#Preview {
    RoutineView()
        .environmentObject(AccentColor())
}
