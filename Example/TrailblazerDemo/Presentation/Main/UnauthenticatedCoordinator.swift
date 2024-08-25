//
//  UnauthenticatedCoordinator.swift
//  TrailblazerDemo
//
//  Created by Alexandr Valíček on 15.08.2024.
//

import Trailblazer
import SwiftUI

@Coordinatable
class UnauthenticatedCoordinator: RootCoordinator {
    @Route func login() -> some View {
        NavigationView {
            List {
                Button("Log in!") { self.setRoot(.authenticated) }
            }
            .navigationTitle("Unauthenticated")
        }
    }
    @Route func authenticated() -> any Coordinatable { AuthenticatedCoordinator() }
    
    override init() {
        super.init()
        setRoot(.login)
    }
}
