import SwiftUI

struct AddProjectView: View {
    @State private var projectName: String = ""
    @State private var deadlineTime = Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date()
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Project name", text: $projectName)
                DatePicker("Deadline", selection: $deadlineTime, in: Date()..., displayedComponents: .date)
                    .datePickerStyle(.graphical)
                
                Button(action: {
                    let newProject = Project(name: projectName, isComplete: false, deadlineTime: deadlineTime)
                    modelContext.insert(newProject)
                    dismiss()
                }) {
                    Text("Create project")
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(projectName.isEmpty ? .gray.opacity(0.5) : .blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .disabled(projectName.isEmpty)
            }
            .navigationTitle("New Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
