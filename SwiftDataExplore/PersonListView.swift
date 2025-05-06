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
    @State private var addPerson = false
    
    var body: some View {
        NavigationStack {
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
            .navigationTitle("People")
            .navigationDestination(for: Person.self) { person in
                PersonDetailView(person: person)
            }
            .toolbar {
                Button("Add", systemImage: "plus") {
                    addPerson = true
                }
            }
        }
        .sheet(isPresented: $addPerson) {
            AddPersonView()
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
        
        return PersonListView()
            .modelContainer(container)
    } catch {
        fatalError("Error: \(error)")
    }
}
