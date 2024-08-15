//
//  RootCoordinatorRootView.swift
//  
//
//  Created by Alexandr Valíček on 06.08.2024.
//

import SwiftUI

internal struct RootCoordinatorRootView: View {
    @StateObject var coordinator: RootCoordinator
    
    func wrappedView(_ route: any RouteWrappable) -> some View {
        Group {
            if let view = route.view {
                view
                    .environmentObjectIfPossible(route.parent)
            } else if let c = route.coordinator as? NavigationCoordinator {
                if coordinator.hasLayerNavigationCoordinator {
                    c.root?.view
                        .environmentObjectIfPossible(c)
                } else {
                    NavigationCoordinatorRootView(coordinator: c)
                        .environmentObjectIfPossible(c)
                }
            } else if let c = route.coordinator as? TabCoordinator {
                c.view
                    .environmentObjectIfPossible(c)
            } else if let c = route.coordinator as? RootCoordinator {
                c.view
                    .environmentObjectIfPossible(c)
            } else {
                 EmptyView()
            }
        }
    }
    
    var body: some View {
        if let root = coordinator.root {
            wrappedView(root)
                .environmentObjectIfPossible(coordinator)
        } else {
            EmptyView()
        }
    }
}
