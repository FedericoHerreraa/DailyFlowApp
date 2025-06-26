//
//  CreateDayView.swift
//  DailyFlowApp
//
//  Created by Federico Herrera on 24/06/2025.
//

import SwiftUI
import SwiftData

struct CreateDayView: View {
    @Environment(\.modelContext) var modelContext
    @Query private var routines: [Routine]
    
    var routineManager: RoutineManager {
        RoutineManager(modelContext: modelContext, routines: routines)
    }
    
    @StateObject var viewModel = CreateDayViewModel()
    @State var updateTask: Bool = false
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
                                                updateTask = true
                                                viewModel.title = task.title
                                                viewModel.description = task.taskDescription
                                                viewModel.startTime = task.startHour
                                                viewModel.endTime = task.endHour
                                            } label: {
                                                Label("Edit", systemImage: "ellipsis")
                                            }
                                            .tint(.gray)
                                        }
                                }
                            }
                        }
                    }
                } else {
                    EmptyView()
                }
                
                Section(header: Text(updateTask ? "Update routine for \(day)" : "Create routine for \(day)")) {
                    TextField("Enter task title", text: $viewModel.title)
                    TextField("Enter task description", text: $viewModel.description)
                    
                    DatePicker("From", selection: $viewModel.startTime, displayedComponents: .hourAndMinute)
                    DatePicker("To", selection: $viewModel.endTime, displayedComponents: .hourAndMinute)
                }
                
                Button {
                    let formValid = viewModel.validateForm()
                    
                    if formValid == nil {
                        let task = Task(
                            title: viewModel.title,
                            description: viewModel.description,
                            startHour: viewModel.startTime,
                            endHour: viewModel.endTime
                        )
                        
                        if updateTask {
                            routineManager.updateTask(updatedTask: task, day: day)
                            updateTask = false
                        } else {
                            routineManager.addTaskToRoutine(task: task, day: day)
                        }
                        
                        viewModel.clear()
                    } else {
                        viewModel.textAlert = formValid!
                        viewModel.showAlert.toggle()
                    }
                } label: {
                    Text(updateTask ? "Update task" : "Save task")
                }
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"), message: Text(viewModel.textAlert), dismissButton: .default(Text("OK")))
        }
    }
}


struct RoutineCreatedView: View {
    @StateObject var viewModel = CreateDayViewModel()
    let task: Task
    
    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 6) {
                Text("\(viewModel.formattedHour(task.startHour)) - \(viewModel.formattedHour(task.endHour))")
                    .font(.caption)
                    .foregroundColor(.black)
                    .bold()
                
                Text(task.title)
                    .font(.headline)
                    .bold()
                    .foregroundColor(.primary)

                if !task.taskDescription.isEmpty {
                    Text(task.taskDescription)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }

            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
            
            Spacer()
            
            VStack(spacing: 4) {
                Image(systemName: "arrow.backward.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.gray)

                Text("Swipe to delete")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.trailing, 4)
        }
    }
}

#Preview {
    CreateDayView(day: "Lunes")
}
