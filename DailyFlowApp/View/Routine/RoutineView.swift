//
//  RoutinesView.swift
//  DailyFlowApp
//
//  Created by Federico Herrera on 24/06/2025.
//

import SwiftUI
import SwiftData


struct RoutineView: View {
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
                                .fill(Color.green)
                                .frame(width: 13, height: 13)
                            
                            Text("With routine")
                                .font(.caption)
                                .foregroundColor(.black)
                                .padding(.leading, 2)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(viewModel.filterByCreated ? Color.green.opacity(0.1) : Color.gray.opacity(0.1))
                        .clipShape(Capsule())
                        .overlay {
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(viewModel.filterByCreated ? Color.green : Color.gray.opacity(0.5), lineWidth: 2)
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
                                .font(.caption)
                                .foregroundColor(.black)
                                .padding(.leading, 2)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(viewModel.filterByNoCreated ? Color.green.opacity(0.1) : Color.gray.opacity(0.1))
                        .clipShape(Capsule())
                        .overlay {
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(viewModel.filterByNoCreated ? Color.green : Color.gray.opacity(0.5), lineWidth: 2)
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
            .navigationTitle("Crea tu rutina")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.showCalendarSheet.toggle()
                    } label: {
                        Image(systemName: "calendar")
                            .resizable()
                            .foregroundColor(.black.opacity(0.8))
                            .scaledToFit()
                            .frame(height: 25)
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Text("Welcome back")
                        .foregroundColor(.black.opacity(0.6))
                }
            }
        }
        .sheet(isPresented: $viewModel.showCalendarSheet) {
            Text("Calendar sheet")
        }
    }
}


struct RoutineItemView: View {
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
                            .fill(routineManager.routineForThatDay(day: day) != nil ? Color.green : Color.gray)
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
