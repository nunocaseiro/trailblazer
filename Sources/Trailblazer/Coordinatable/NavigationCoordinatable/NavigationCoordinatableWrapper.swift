//
//  NavigationCoordinatableWrapper.swift
//  
//
//  Created by Alexandr Valíček on 14.08.2024.
//

import SwiftUI

extension NavigationCoordinatable {
    func prepareWrapper(
        for route: Routes,
        with modifier: ((any View) -> any View)? = nil
    ) -> RouteWrapper {
        if var wrapper = createRouteWrapper(from: route) as? RouteWrapper {
            wrapper.modifier = modifier.map { m in
                AnyViewModifier { AnyView(m($0)) }
            } ?? .identity
            
            if let coordinator = wrapper.coordinator {
                coordinator.parent = self
                coordinator.hasLayerNavigationCoordinator = true
            }
            
            return wrapper
        } else {
            return RouteWrapper(parent: self, route: route, view: EmptyView())
        }
    }
}
