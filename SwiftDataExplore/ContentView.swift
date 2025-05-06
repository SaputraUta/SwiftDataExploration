//
//  ContentView.swift
//  SwiftDataExplore
//
//  Created by Saputra on 05/05/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query var projects: [Project]
    @Environment(\.modelContext) var modelContext
    @State private var addProject = false
    var body: some View {
        NavigationStack {
            List {
                ForEach(projects) { project in
                    NavigationLink(value: project) {
                        VStack(alignment: .leading, spacing: 16) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(project.name)
                                    .font(.headline)
                                Text("Created at " + dateFormatter(project.createdTime))
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            HStack {
                                Text(dateFormatter(project.deadlineTime))
                                    .font(.caption)
                                Spacer()
                                Text("Task:  \(Int(project.progressPercentage)) %")
                                    .font(.caption)
                            }
                        }
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        modelContext.delete(projects[index])
                    }
                }
            }
            .navigationDestination(for: Project.self) { project in
                ProjectDetailView(project: project)
            }
            .navigationTitle("Project Tracker")
            .toolbar {
                Button("Add", systemImage: "plus") {
                    addProject = true
                }
            }
        }
        
        .sheet(isPresented: $addProject) {
            AddProjectView()
        }
    }
}

#Preview {
    do {
        let container = try ModelContainer(for: Project.self, Job.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let context = container.mainContext
        
        let project = Project(name: "Project Alpha", isComplete: false, deadlineTime: .now)
        let task1 = Job(title: "Task 1", isCompleted: false, project: project)
        let task2 = Job(title: "Task 2", isCompleted: true, project: project)
        project.jobs = [task1, task2]
        
        context.insert(project)
        
        return ContentView()
            .modelContainer(container)
    } catch {
        fatalError("Error: \(error)")
    }
}
