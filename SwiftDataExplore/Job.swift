//
//  Task.swift
//  SwiftDataExplore
//
//  Created by Saputra on 05/05/25.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Job {
    var title: String
    var isCompleted: Bool
    var createdTime: Date
    var deadlineTime: Date?
    var points: Int
    var statusValue: String
    var project: Project?
    var assignee: Person?
    
    init(title: String, isCompleted: Bool, createdTime: Date = Date(), deadlineTime: Date? = nil, points: Int = 1, status: JobStatus = .inProgress, project: Project? = nil, assignee: Person? = nil) {
        self.title = title
        self.isCompleted = isCompleted
        self.createdTime = createdTime
        self.deadlineTime = deadlineTime
        self.points = points
        self.statusValue = status.rawValue
        self.project = project
        self.assignee = assignee
    }
    
    var status: JobStatus {
        get {
            return JobStatus(rawValue: statusValue) ?? .inProgress
        }
        set {
            statusValue = newValue.rawValue
            isCompleted = (newValue == .done)
        }
    }
    
    var remainingTime: TimeInterval? {
        guard let deadline = deadlineTime else { return nil }
        return deadline.timeIntervalSince(Date())
    }
    
    var isOverdue: Bool {
        guard let deadline = deadlineTime else { return false }
        return Date() > deadline && status != .done
    }
}


enum JobStatus: String, Codable, CaseIterable {
    case inProgress = "In Progress"
    case inReview = "In Review"
    case done = "Done"
    case cancelled = "Cancelled"
    
    
    var icon: String {
        switch self {
            case .inProgress: return "circle"
            case .inReview: return "hourglass"
            case .done: return "checkmark.circle.fill"
            case .cancelled: return "xmark.circle"
        }
    }
    
    var color: Color {
        switch self {
        case .inProgress: return .blue
        case .inReview : return .orange
        case .done: return .green
        case .cancelled: return .gray
        }
    }
}
