//
//  MoThoughtsApp.swift
//  MoThoughts
//
//  Created by Mohameth Seck on 11/20/24.
//

import SwiftUI
import SwiftData

@main
struct MoThoughtsApp: App {
        
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Note.self)
        }
    }
}
