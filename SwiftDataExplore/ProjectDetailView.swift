//
//  ProjectDetailView.swift
//  SwiftDataExplore
//
//  Created by Saputra on 05/05/25.
//

import SwiftUI
import SwiftData

struct ProjectDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var newTaskTitle = ""
    @State private var newTaskName = ""
    @State private var showStatusPicker = false
    @State private var selectedJob: Job? = nil
    @State private var showAllTask = false
    
    enum SortOption: String, CaseIterable {
        case deadline = "Deadline"
        case points = "Points"
    }
    @State private var selectedSort: SortOption = .deadline
    
    var project: Project
    @State private var addTask = false
    var body: some View {
        Form {
            
            Section {
                Toggle("Show Completed Tasks", isOn: $showAllTask)
                Picker("Sort by", selection: $selectedSort) {
                    ForEach(SortOption.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            Section("Tasks") {
                ForEach(displayedJobs) { job in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(job.title)
                                .font(.headline)
                            Spacer()
                            Text(String(job.points))
                                .font(.subheadline)
                                .foregroundStyle(job.points < 3 ? .green : job.points <= 4 ? .yellow : .red)
                        }
                        Text("Assigned to \(job.assignee?.name ?? "No Assignee") at \(dateFormatter(job.createdTime))")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Text("\(dateFormatter(job.deadlineTime))")
                            .font(.callout)
                        Button(action: {
                            selectedJob = job
                            showStatusPicker = true
                        }) {
                            HStack {
                                Image(systemName: job.status.icon)
                                    .foregroundStyle(job.status.color)
                                Text(job.statusValue)
                                    .foregroundStyle(job.status.color)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                            .font(.subheadline)
                            .padding(.vertical, 4)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        modelContext.delete(project.jobs[index])
                    }
                }
            }
        }
        .toolbar {
            Button("Add", systemImage: "plus") {
                addTask = true
            }
        }
        .navigationTitle(project.name)
        .sheet(isPresented: $addTask) {
            AddTaskView(project: project, taskName: $newTaskName)
        }
        .sheet(item: $selectedJob) { job in
                StatusPickerView(job: job)
        }
    }
    
    var displayedJobs: [Job] {
        let jobs = showAllTask ? project.jobs : project.jobs.filter { !$0.isCompleted }
        return sortJobs(jobs)
    }
    
    func sortJobs(_ jobs: [Job]) -> [Job] {
        switch selectedSort {
        case .deadline:
            return jobs.sorted {
                ($0.deadlineTime ?? Date.distantFuture) < ($1.deadlineTime ?? Date.distantFuture)
            }
        case .points:
            return jobs.sorted { $0.points > $1.points }
        }
    }
}

#Preview {
    do {
        let container = try ModelContainer(for: Project.self, Job.self, Person.self)
        let context = container.mainContext
        
        let project = Project(name: "Testing project", isComplete: false, deadlineTime: .now)
        let person = Person(name: "Uta", role: .designer)
        let job = Job(title: "Test job", isCompleted: false, deadlineTime: .now, points: 5, status: .inProgress, project: project, assignee: person)
        
        context.insert(project)
        context.insert(person)
        context.insert(job)
        
        return ProjectDetailView(project: project)
            .modelContainer(container)
    } catch {
        fatalError("Failed to load preview: \(error)")
    }
}
