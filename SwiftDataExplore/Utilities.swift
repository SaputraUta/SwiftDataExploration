//
//  Utilities.swift
//  SwiftDataExplore
//
//  Created by Saputra on 06/05/25.
//

import Foundation

func dateFormatter(_ date: Date?) -> String {
    if let date = date {
        return "Due to \(date.formatted(date: .abbreviated, time: .omitted))"
    } else {
        return "No deadline yet"
    }
}
