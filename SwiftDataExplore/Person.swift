//
//  Person.swift
//  SwiftDataExplore
//
//  Created by Saputra on 06/05/25.
//

import Foundation
import SwiftData

@Model
class Person {
    var name: String
    var role: String
    @Relationship(deleteRule: .nullify, inverse: \Job.assignee) var jobs: [Job] = []
    
    init(name: String, role: PersonRole) {
        self.name = name
        self.role = role.rawValue
    }
    
    var roleEnum: PersonRole {
        get {
            return PersonRole(rawValue: role) ?? .other
        }
        
        set {
            role = newValue.rawValue
        }
    }
}

enum PersonRole: String, Codable, CaseIterable {
    case designer = "Designer"
    case developer = "Developer"
    case productManager = "Product Manager"
    case tester = "Tester"
    case other = "Other"
}
