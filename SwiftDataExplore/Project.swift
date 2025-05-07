//
//  Project.swift
//  SwiftDataExplore
//
//  Created by Saputra on 05/05/25.
//

import Foundation
import SwiftData

@Model
class Project {
    #Unique<Project>([\.name])
    #Index<Project>([\.name])
    
    var name: String
    var isComplete: Bool
    var createdTime: Date
    var deadlineTime: Date?
    @Relationship(deleteRule: .cascade) var jobs: [Job] = []
    
    init(name: String, isComplete: Bool = false, createdTime: Date = Date(), deadlineTime: Date? = nil) {
        self.name = name
        self.isComplete = isComplete
        self.createdTime = createdTime
        self.deadlineTime = deadlineTime
    }
    
    var totalPoints: Int {
        jobs.reduce(0) { $0 + $1.points}
    }
    
    var completedPoints: Int {
        jobs.filter { $0.isCompleted }.reduce(0) { $0 + $1.points }
    }
    
    var progressPercentage: Double {
        totalPoints > 0 ? Double(completedPoints) / Double(totalPoints) * 100 : 0
    }
}
