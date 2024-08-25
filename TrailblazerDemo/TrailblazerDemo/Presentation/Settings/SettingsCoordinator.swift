//
//  SettingsCoordinator.swift
//  TrailblazerDemo
//
//  Created by Alexandr Valíček on 08.08.2024.
//

import Trailblazer
import SwiftUI

@Coordinatable
final class SettingsCoordinator: NavigationCoordinator {
    @Route func root() -> some View { SettingsView() }
    @Route func someDetail() -> some View { SomeSettingsView() }
    
    override init() {
        super.init()
        setRoot(.root)
    }
}
