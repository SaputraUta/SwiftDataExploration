//
//  ContentView.swift
//  SwiftDataExplore
//
//  Created by Saputra on 05/05/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var addProject = false
    @State private var sortOrder = [
        SortDescriptor(\Project.deadlineTime),
        SortDescriptor(\Project.name)
    ]
    @State private var searchtext = ""
    
    var body: some View {
        NavigationStack {
            ProjectList(sortOrder: sortOrder, searchText: searchtext)
            .navigationDestination(for: Project.self) { project in
                ProjectDetailView(project: project)
            }
            .navigationTitle("Project Tracker")
            .toolbar {
                Menu("Sort", systemImage: "arrow.up.arrow.down"){
                    Picker("Sort", selection: $sortOrder) {
                        Text("Sort by Deadline")
                            .tag([
                                SortDescriptor(\Project.deadlineTime),
                                SortDescriptor(\Project.name)
                            ])
                        Text("Sort by Name")
                            .tag([
                                SortDescriptor(\Project.name),
                                SortDescriptor(\Project.deadlineTime)
                            ])
                    }
                }
                Button("Add", systemImage: "plus") {
                    addProject = true
                }
            }
        }
        .searchable(text: $searchtext, prompt: "Search by name")
        
        .sheet(isPresented: $addProject) {
            AddProjectView()
        }
    }
}

#Preview {
    do {
        let container = try ModelContainer(for: Project.self, Job.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let context = container.mainContext
        
        let project = Project(name: "Project Beta", isComplete: false, deadlineTime: .now)
        let task1 = Job(title: "Task 1", isCompleted: false, project: project)
        let task2 = Job(title: "Task 2", isCompleted: true, project: project)
        let project2 = Project(name: "Alpha Project", isComplete: false, deadlineTime: Calendar.current.date(byAdding: .month, value: 1, to: Date() ?? Date()))
        let task3 = Job(title: "Rask 1", isCompleted: false, project: project)
        let task4 = Job(title: "Rask 2", isCompleted: true, project: project)
        project.jobs = [task1, task2]
        project2.jobs = [task3, task4]
        
        context.insert(project)
        context.insert(project2)
        
        return ContentView()
            .modelContainer(container)
    } catch {
        fatalError("Error: \(error)")
    }
}
