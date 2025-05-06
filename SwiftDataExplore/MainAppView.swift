//
//  MainAppView.swift
//  SwiftDataExplore
//
//  Created by Saputra on 06/05/25.
//

import SwiftUI
import SwiftData

struct MainAppView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Projects", systemImage: "folder")
                }
            
            PersonListView()
                .tabItem {
                    Label("People", systemImage: "person.2")
                }
        }
    }
}

#Preview {
    do {
        let container = try ModelContainer(for: Project.self, Job.self, Person.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let context = container.mainContext
        
        let project = Project(name: "Project Alpha", isComplete: false, deadlineTime: .now)
        let task1 = Job(title: "Task 1", isCompleted: false, project: project)
        let task2 = Job(title: "Task 2", isCompleted: true, project: project)
        project.jobs = [task1, task2]
        let person = Person(name: "Uta", role: .designer)
        let person2 = Person(name: "Putra", role: .developer)
        
        context.insert(project)
        context.insert(person)
        context.insert(person2)
        
        return MainAppView()
            .modelContainer(container)
    } catch {
        fatalError("Error: \(error)")
    }
}
