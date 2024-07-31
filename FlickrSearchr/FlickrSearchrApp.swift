//
//  FlickrSearchrApp.swift
//  FlickrSearchr
//
//  Created by Keith Weiss on 7/30/24.
//

import SwiftUI
import SwiftData

@main
struct FlickrSearchrApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FlickrStore.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
