//
//  RootCoordinatableWrapper.swift
//  
//
//  Created by Alexandr Valíček on 14.08.2024.
//

import SwiftUI

extension RootCoordinatable {
    func prepareWrapper(for route: Routes) -> RouteWrapper {
        if var wrapper = createRouteWrapper(from: route) as? RouteWrapper {
            wrapper.modifier = .identity
            
            if let coordinator = wrapper.coordinator {
                coordinator.parent = self
                coordinator.hasLayerNavigationCoordinator = parent?.hasLayerNavigationCoordinator ?? false
            }
            
            return wrapper
        } else {
            return RouteWrapper(parent: self, route: route, view: EmptyView())
        }
    }
}
