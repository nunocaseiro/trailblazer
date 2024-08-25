//
//  AuthenticatedCoordinator.swift
//  TrailblazerDemo
//
//  Created by Alexandr Valíček on 14.08.2024.
//

import Trailblazer
import SwiftUI

@Coordinatable
class AuthenticatedCoordinator: TabCoordinator {
    @Route func home() -> (any Coordinatable, some View) {(
        HomeCoordinator(),
        Label("Home", systemImage: "house")
    )}
    @Route func settings() -> (any Coordinatable, some View) {(
        SettingsCoordinator(),
        Label("Settings", systemImage: "gear")
    )}
    @Route func testbed() -> (any Coordinatable, some View) {(
        TestbedCoordinator(count: 0),
        Label("Testbed", systemImage: "bed.double")
    )}
    
    override init() {
        super.init()
        setTabs([
            .home,
            .settings,
            .testbed
        ])
    }
}
