//
//  TestbedCoordinator.swift
//  TrailblazerDemo
//
//  Created by Alexandr Valíček on 15.08.2024.
//

import Trailblazer
import SwiftUI

@Coordinatable
class TestbedCoordinator: NavigationCoordinator {
    @Route func testbedCoordinator() -> any Coordinatable { TestbedCoordinator(count: count + 1) }
    @Route func settingsCoordinator() -> any Coordinatable { SettingsCoordinator() }
    @Route func testbedView() -> some View { TestbedView() }
    
    let count: Int
    @Published var text: String = String()
    
    init(count: Int) {
        self.count = count
        super.init()
        setRoot(.testbedView)
    }
}
