//
//  PeoplePageView.swift
//  SwiftDataExplore
//
//  Created by Saputra on 07/05/25.
//

import SwiftUI
import SwiftData

struct PeoplePageView: View {
    @State private var addPerson = false
    @State private var sortOrder = [
        SortDescriptor(\Person.name),
        SortDescriptor(\Person.ongoingTaskCount, order: .reverse)
    ]
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            PersonListView(sortOrder: sortOrder, searchText: searchText)
                .navigationTitle("People")
                .navigationDestination(for: Person.self) { person in
                    PersonDetailView(person: person)
                }
                .toolbar {
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $sortOrder) {
                            Text("Sort by name")
                                .tag([
                                    SortDescriptor(\Person.name),
                                    SortDescriptor(\Person.ongoingTaskCount, order: .reverse)
                                ])
                            Text("Sort by Jobs")
                                .tag([
                                    SortDescriptor(\Person.ongoingTaskCount, order: .reverse),
                                    SortDescriptor(\Person.name)
                                ])
                        }
                    }
                    Button("Add", systemImage: "plus") {
                        addPerson = true
                    }
                }
        }
        .searchable(text: $searchText, prompt: "Search by name")
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
        let person3 = Person(name: "Atu", role: .other)
        context.insert(person3)
        context.insert(person)
        context.insert(person2)
        let job = Job(title: "Test job", isCompleted: false, deadlineTime: .now, points: 2, status: .inProgress, project: project, assignee: person)
        context.insert(job)
        
        return PeoplePageView()
            .modelContainer(container)
    } catch {
        fatalError("Error: \(error)")
    }
}
