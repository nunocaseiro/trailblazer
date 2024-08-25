//
//  SomeSettingsView.swift
//  TrailblazerDemo
//
//  Created by Alexandr Valíček on 15.08.2024.
//

import SwiftUI

struct SomeSettingsView: View {
    @EnvironmentObject var c: SettingsCoordinator
    
    var body: some View {
        List {
            Button("Some detail") { c.route(to: .someDetail) }
        }
        .navigationTitle("Some detail")
    }
}

#Preview {
    NavigationStack {
        SomeSettingsView()
    }
}
