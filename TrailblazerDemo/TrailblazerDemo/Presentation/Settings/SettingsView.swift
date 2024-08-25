//
//  SettingsView.swift
//  TrailblazerDemo
//
//  Created by Alexandr Valíček on 08.08.2024.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var coordinator: SettingsCoordinator
    @EnvironmentObject var unauth: UnauthenticatedCoordinator
    
    var body: some View {
        VStack {
            List {
                Button("Some subsetting") {
                    coordinator.route(to: .someDetail)
                }
                
                Button("Log out") {
                    unauth.setRoot(.login)
                }
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
