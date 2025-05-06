//
//  ProjectList.swift
//  SwiftDataExplore
//
//  Created by Saputra on 06/05/25.
//

import SwiftUI
import SwiftData

struct ProjectList: View {
    @Query var projects: [Project]
    @Environment(\.modelContext) var modelContext
    
    init(sortOrder: [SortDescriptor<Project>], searchText: String) {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            _projects = Query(sort: sortOrder)
        } else {
            _projects = Query(filter: #Predicate<Project> { project in
                project.name.localizedStandardContains(trimmed)
            } ,sort: sortOrder)
        }
    }
    
    
    var body: some View {
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
    }
}

#Preview {
    do {
        let container = try ModelContainer(for: Project.self, Job.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let context = container.mainContext
        
        let project = Project(name: "Project Alpha", isComplete: false, deadlineTime: .now)
        let task1 = Job(title: "Task 1", isCompleted: false, project: project)
        let task2 = Job(title: "Task 2", isCompleted: true, project: project)
        let project2 = Project(name: "Alpha Project", isComplete: false, deadlineTime: Calendar.current.date(byAdding: .month, value: 1, to: Date() ?? Date()))
        let task3 = Job(title: "Rask 1", isCompleted: false, project: project)
        let task4 = Job(title: "Rask 2", isCompleted: true, project: project)
        project.jobs = [task1, task2]
        project2.jobs = [task3, task4]
        
        context.insert(project)
        context.insert(project2)
        
        return NavigationStack {
            ProjectList(sortOrder: [
                SortDescriptor(\Project.deadlineTime),
                SortDescriptor(\Project.name)
            ], searchText: "")
        }
            .modelContainer(container)
    } catch {
        fatalError("Error: \(error)")
    }
}
