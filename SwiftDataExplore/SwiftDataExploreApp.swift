//
//  SwiftDataExploreApp.swift
//  SwiftDataExplore
//
//  Created by Saputra on 05/05/25.
//

import SwiftUI
import SwiftData

@main
struct SwiftDataExploreApp: App {
    var body: some Scene {
        WindowGroup {
            MainAppView()
        }
        .modelContainer(for: [Project.self, Job.self, Person.self])
    }
}
