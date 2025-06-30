//
//  RoutinesView.swift
//  DailyFlowApp
//
//  Created by Federico Herrera on 24/06/2025.
//

import SwiftUI
import SwiftData


struct RoutineView: View {
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
                            
                            Text("With routine")
                                .font(.subheadline)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .padding(.leading, 2)
                                .fontDesign(.rounded)
                            
                            Image(systemName: viewModel.filterByCreated ? "minus" : "plus")
                                .foregroundColor(accentColor.color)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(viewModel.filterByCreated ? accentColor.color.opacity(0.1) : Color.gray.opacity(0.1))
                        .clipShape(Capsule())
                        .overlay {
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(viewModel.filterByCreated ? accentColor.color : Color.gray.opacity(0.5), lineWidth: 2)
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
                            
                            Text("Without routine")
                                .font(.subheadline)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .padding(.leading, 2)
                                .fontDesign(.rounded)
                            
                            Image(systemName: viewModel.filterByNoCreated ? "minus" : "plus")
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(viewModel.filterByNoCreated ? accentColor.color.opacity(0.1) : Color.gray.opacity(0.1))
                        .clipShape(Capsule())
                        .overlay {
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(viewModel.filterByNoCreated ? accentColor.color : Color.gray.opacity(0.5), lineWidth: 2)
                        }
                    }

                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                List {
                    ForEach(routineManager.weekdays, id: \.self) { day in
                        RoutineItemView(day: day, routineManager: routineManager, viewModel: viewModel)
                    }
                }
                .listStyle(.plain)
                .padding(.top, 20)
            }
            .navigationTitle("Create your routine")
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
                    Text("Welcome back")
                        .foregroundColor(colorScheme == .dark ? .white.opacity(0.6) : .black.opacity(0.6))
                        .fontDesign(.rounded)
                }
            }
        }
        .sheet(isPresented: $viewModel.showCalendarSheet) {
            MonthSheetCalendarView(showCalendarSheet: $viewModel.showCalendarSheet)
        }
    }
}


struct RoutineItemView: View {
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
                    Text(routineManager.routineForThatDay(day: day) != nil ? "You already have a routine" : "You don't have a routine yet")
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

#Preview {
    RoutineView()
}
