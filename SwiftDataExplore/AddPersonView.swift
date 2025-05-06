//
//  AddPersonView.swift
//  SwiftDataExplore
//
//  Created by Saputra on 06/05/25.
//

import SwiftUI

struct AddPersonView: View {
    @State private var personName: String = ""
    @State private var selectedRole: PersonRole = .developer
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Person name", text: $personName)
                Picker("Role", selection: $selectedRole) {
                    ForEach(PersonRole.allCases, id: \.self) { role in
                        Text(role.rawValue).tag(role)
                    }
                }
                .pickerStyle(.menu)
                
                Button(action: {
                    let newPerson = Person(name: personName, role: selectedRole)
                    modelContext.insert(newPerson)
                    personName = ""
                    selectedRole = .developer
                    dismiss()
                }) {
                    Text("Add Person")
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(personName.isEmpty ? .gray.opacity(0.5) : .blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .disabled(personName.isEmpty)
            }
            .navigationTitle("New Person")
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

#Preview {
    AddPersonView()
}
