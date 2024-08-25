//
//  TrailblazerDemoApp.swift
//  TrailblazerDemo
//
//  Created by Alexandr Valíček on 08.08.2024.
//

import SwiftUI

@main
struct TrailblazerDemoApp: App {
    let coordinator = UnauthenticatedCoordinator()
    
    var body: some Scene {
        WindowGroup {
            coordinator.view
        }
    }
}
