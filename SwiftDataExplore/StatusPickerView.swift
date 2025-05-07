//
//  StatusPickerView.swift
//  SwiftDataExplore
//
//  Created by Saputra on 06/05/25.
//

import SwiftUI
import SwiftData

struct StatusPickerView: View {
    @Environment(\.dismiss) private var dismiss
    var job: Job
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(JobStatus.allCases, id: \.self) { status in
                    Button {
                        job.status = status
                        if let person = job.assignee {
                            updateOngoingCount(for: person)
                        }
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: status.icon)
                                .foregroundStyle(status.color)
                            Text(status.rawValue)
                                .foregroundStyle(.black)
                            Spacer()
                            if job.status == status {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Change Status")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
}

#Preview {
    do {
        let container = try ModelContainer(for: Project.self, Job.self, Person.self)
        let context = container.mainContext
        
        let job = Job(title: "Test job", isCompleted: false, deadlineTime: .now, points: 5, status: .inProgress)
        context.insert(job)
        
        return StatusPickerView(job: job)
            .modelContainer(container)
    } catch {
        fatalError("Failed to load preview: \(error)")
    }
}
