//
//  PersonDetailView.swift
//  SwiftDataExplore
//
//  Created by Saputra on 06/05/25.
//

import SwiftUI
import SwiftData

struct PersonDetailView: View {
    var person: Person
    var body: some View {
        Form {
            Text(person.role)
                .font(.headline)
            List {
                ForEach(person.jobs) { job in
                    NavigationLink(value: job.project) {
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
                            Text("Due to \(dateFormatter(job.deadlineTime))")
                                .font(.callout)
                            HStack {
                                Image(systemName: job.status.icon)
                                    .foregroundStyle(job.status.color)
                                Text(job.statusValue)
                                    .foregroundStyle(job.status.color)
                                Spacer()
                            }
                            .font(.subheadline)
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
        }
        .navigationTitle(person.name)
        .navigationDestination(for: Project.self) { project in
            ProjectDetailView(project: project)
        }
    }
}

#Preview {
    do {
        let container = try ModelContainer(for: Project.self, Job.self, Person.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        let project = Project(name: "Testing project", isComplete: false, deadlineTime: .now)
        let person = Person(name: "Uta", role: .designer)
        let job = Job(title: "Test job", isCompleted: false, deadlineTime: .now, points: 2, status: .inProgress, project: project, assignee: person)
        
        return NavigationStack {
            PersonDetailView(person: person)
        }
        .modelContainer(container)
    } catch {
        fatalError("Error: \(error)")
    }
}
