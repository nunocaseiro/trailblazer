//
//  TestbedView.swift
//  TrailblazerDemo
//
//  Created by Alexandr Valíček on 15.08.2024.
//

import SwiftUI

struct TestbedView: View {
    @EnvironmentObject var c: TestbedCoordinator
    @Environment(\.dismiss) var dismiss
    
    @State var localText: String = String()
    
    var body: some View {
        VStack {
            List {
                Section("TextFields") {
                    TextField("Coordinator-shared", text: $c.text)
                    TextField("Local-only", text: $localText)
                }
                Section("View") {
                    Button("Route") { c.route(to: .testbedView)}
                    Button("Present (.sheet)") { c.present(.testbedView, as: .sheet)}
                    Button("Present (.fullScreenCover)") { c.present(.testbedView, as: .fullScreenCover)}
                }
                Section("Coordinatable") {
                    Button("Route") { c.route(to: .testbedCoordinator)}
                    Button("Present (.sheet)") { c.present(.testbedCoordinator, as: .sheet)}
                    Button("Present (.fullScreenCover)") { c.present(.testbedCoordinator, as: .fullScreenCover)}
                }
                Section("Dismiss") {
                    Button("Dismiss (environment)") { dismiss() }
                    Button("Dismiss (pop)") { c.pop() }
                    Button("Dismiss (dismissCoordinator)") { c.dismissCoordinator() }
                }
                Section("Nested routing") {
                    Button("To settings > some Detail") {
                        c.route(to: .settingsCoordinator) { (s: SettingsCoordinator) in
                            s.route(to: .someDetail)
                        }
                    }
                }
            }
        }
        .navigationTitle("Testbed \(c.count)")
    }
}

#Preview {
    NavigationStack {
        TestbedView()
    }
}
