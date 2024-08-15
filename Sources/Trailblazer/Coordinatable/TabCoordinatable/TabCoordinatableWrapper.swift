//
//  TabCoordinatableWrapper.swift
//  
//
//  Created by Alexandr Valíček on 14.08.2024.
//

import SwiftUI

public extension TabCoordinatable {
    func prepareViewWrapper(
        route: Routes,
        view: some View,
        tabItem: some View
    ) -> TabRouteWrapper {
        TabRouteWrapper(parent: self, route: route, view: AnyView(view), tabItem: AnyView(tabItem))
    }
    
    func prepareCoordinatorWrapper(
        route: Routes,
        coordinatorFactory: @escaping () -> any Coordinatable,
        tabItem: some View
    ) -> TabRouteWrapper {
        lazy var coordinator: any Coordinatable = { [unowned self] in
            let v = coordinatorFactory()
            v.parent = self
            v.hasLayerNavigationCoordinator = parent?.hasLayerNavigationCoordinator ?? false
            return v
        }()
        
        return TabRouteWrapper(parent: self, route: route, coordinatorFactory: { coordinator }, tabItem: AnyView(tabItem))
    }
}
