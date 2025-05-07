//
//  PersonListView.swift
//  SwiftDataExplore
//
//  Created by Saputra on 06/05/25.
//

import SwiftUI
import SwiftData

struct PersonListView: View {
    @Query var people: [Person]
    @Environment(\.modelContext) var modelContext
    
    init(sortOrder: [SortDescriptor<Person>], searchText: String) {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            _people = Query(sort: sortOrder)
        } else {
            _people = Query(filter: #Predicate<Person> { person in
                person.name.localizedStandardContains(trimmed)
            }, sort: sortOrder)
        }
    }
    
    var body: some View {
            List {
                ForEach(people) { person in
                    NavigationLink(value: person) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(person.name)
                                .font(.headline)
                            HStack {
                                Text(person.role)
                                Spacer()
                                Text("Ongoing task: \(person.jobs.filter { $0.status == .inProgress }.count)")
                            }
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        modelContext.delete(people[index])
                    }
                }
            }
    }
}

#Preview {
    do {
        let container = try ModelContainer(for: Project.self, Job.self, Person.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let context = container.mainContext
        
        let project = Project(name: "Testing project", isComplete: false, deadlineTime: .now)
        let person = Person(name: "Uta", role: .designer)
        let person2 = Person(name: "Putra", role: .developer)
        context.insert(person)
        context.insert(person2)
        let job = Job(title: "Test job", isCompleted: false, deadlineTime: .now, points: 2, status: .inProgress, project: project, assignee: person)
        context.insert(job)
        
        return NavigationStack {
            PersonListView(sortOrder: [SortDescriptor(\Person.name)], searchText: "")
        }
            .modelContainer(container)
    } catch {
        fatalError("Error: \(error)")
    }
}
