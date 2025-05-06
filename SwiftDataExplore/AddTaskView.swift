//
//  AddTaskView.swift
//  SwiftDataExplore
//
//  Created by Saputra on 05/05/25.
//

import SwiftUI
import SwiftData

struct AddTaskView: View {
    @Query var people: [Person]
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Bindable var project: Project
    @Binding var taskName: String
    @State private var selectedPerson: Person?
    @State private var selectedDeadline = Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date()
    @State private var selectedPoint = 1
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Task name", text: $taskName)
                Picker("Person", selection: $selectedPerson) {
                    if people.isEmpty {
                        Text("No person available").tag(PersonRole.other)
                    } else {
                        ForEach(people, id: \.self) { person in
                            Text(person.name).tag(Optional(person))
                        }
                    }
                }
                .pickerStyle(.menu)
                Picker("Point", selection: $selectedPoint) {
                    ForEach(1...5, id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
                }
                .pickerStyle(.menu)
                DatePicker("Deadline", selection: $selectedDeadline, in: Date()..., displayedComponents: .date)
                    .datePickerStyle(.graphical)
                Button(action: {
                    let newJob = Job(title: taskName, isCompleted: false, deadlineTime: selectedDeadline, points: selectedPoint, project: project)
                    newJob.assignee = selectedPerson
                    project.jobs.append(newJob)
                    selectedPerson = nil
                    selectedDeadline = Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date()
                    selectedPoint = 1
                    taskName = ""
                    dismiss()
                }) {
                    Text("Add")
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(taskName.isEmpty ? Color.gray : Color.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .disabled(taskName.isEmpty)
            }
            .navigationTitle("Add task to \(project.name)")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    AddTaskView(project: Project(name: "Testing", isComplete: false), taskName: .constant("Test"))
}
