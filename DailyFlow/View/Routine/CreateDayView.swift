//
//  CreateDayView.swift
//  DailyFlowApp
//
//  Created by Federico Herrera on 24/06/2025.
//

import SwiftUI
import SwiftData

struct CreateDayView: View {
    @EnvironmentObject private var accentColor: AccentColor
    @Environment(\.modelContext) var modelContext
    @Query private var routines: [Routine]
    
    var routineManager: RoutineManager {
        RoutineManager(modelContext: modelContext, routines: routines)
    }
    
    @StateObject var viewModel = CreateDayViewModel()
    let day: String
   
    
    var body: some View {
        NavigationView {
            Form {
                if let routine = routineManager.routineForThatDay(day: day) {
                    if routine.tasks.isEmpty {
                        EmptyView()
                    } else {
                        Section(header: Text("Routine for \(day)")) {
                            List {
                                ForEach(routine.tasks) { task in
                                    RoutineCreatedView(task: task)
                                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                            Button(role: .destructive) {
                                                routineManager.deleteTask(task, from: day)
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                            
                                            
                                            Button {
                                                viewModel.updateTask = true
                                                viewModel.taskId = task.id
                                                viewModel.title = task.title
                                                viewModel.description = task.taskDescription
                                                viewModel.startTime = task.startHour
                                                viewModel.endTime = task.endHour
                                            } label: {
                                                Label("Edit", systemImage: "ellipsis")
                                            }
                                            .tint(.gray.opacity(0.5))
                                        }
                                }
                            }
                        }
                    }
                } else {
                    EmptyView()
                }
                
                Section(header: Text(viewModel.updateTask ? "Update routine for \(day)" : "Create routine for \(day)")) {
                    TextField("Enter task title", text: $viewModel.title)
                    TextField("Enter task description", text: $viewModel.description)
                    
                    DatePicker("From", selection: $viewModel.startTime, displayedComponents: .hourAndMinute)
                    DatePicker("To", selection: $viewModel.endTime, displayedComponents: .hourAndMinute)
                }
                
                Button {
                    let formValid = viewModel.validateForm()
                    
                    if formValid == nil {
                        if viewModel.updateTask {
                            let task = Task(
                                id: viewModel.taskId,
                                title: viewModel.title,
                                description: viewModel.description,
                                startHour: viewModel.startTime,
                                endHour: viewModel.endTime
                            )
                            routineManager.updateTask(updatedTask: task, day: day)
                            viewModel.updateTask = false
                        } else {
                            let task = Task(
                                title: viewModel.title,
                                description: viewModel.description,
                                startHour: viewModel.startTime,
                                endHour: viewModel.endTime
                            )
                            routineManager.addTaskToRoutine(task: task, day: day)
                        }
                        
                        viewModel.clear()
                    } else {
                        viewModel.textAlert = formValid!
                        viewModel.showAlert.toggle()
                    }
                } label: {
                    Text(viewModel.updateTask ? "Update task" : "Save task")
                        .foregroundColor(accentColor.color)
                        .fontDesign(.rounded)
                }
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"), message: Text(viewModel.textAlert), dismissButton: .default(Text("OK")))
        }
    }
}


struct RoutineCreatedView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var accentColor: AccentColor
    @StateObject var viewModel = CreateDayViewModel()
    let task: Task
    
    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 3) {
                Text("\(viewModel.formattedHour(task.startHour)) - \(viewModel.formattedHour(task.endHour))")
                    .font(.subheadline)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .fontDesign(.rounded)
                
                Text(task.title)
                    .font(.headline)
                    .bold()
                    .foregroundColor(.primary)
                    .fontDesign(.rounded)

                if !task.taskDescription.isEmpty {
                    Text(task.taskDescription)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .fontDesign(.rounded)
                }

            }
            .padding(10)
            .background(colorScheme == .dark ? Color.gray.opacity(0.2) : Color(.systemGray6))
            .cornerRadius(8)
            
            Spacer()
            
            VStack(spacing: 6) {
                Image(systemName: "arrow.backward.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(accentColor.color)

                Text("Swipe to delete")
                    .font(.caption2)
                    .foregroundColor(colorScheme == .dark ? .white.opacity(0.8) : .gray)
                    .multilineTextAlignment(.center)
                    .fontDesign(.rounded)
            }
            .padding(.trailing, 4)
        }
    }
}

#Preview {
    CreateDayView(day: "Lunes")
        .environmentObject(AccentColor())
}
