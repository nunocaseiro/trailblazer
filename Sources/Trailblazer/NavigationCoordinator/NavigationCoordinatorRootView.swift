//
//  NavigationCoordinatorRootView.swift
//  
//
//  Created by Alexandr Valíček on 29.07.2024.
//

import SwiftUI

internal struct NavigationCoordinatorRootView: View {
    @StateObject var coordinator: NavigationCoordinator
    
    func wrappedView(_ route: any RouteWrappable) -> some View {
        Group {
            if let view = route.view {
                view
                    .environmentObjectIfPossible(route.parent)
            } else if let c = route.coordinator as? NavigationCoordinator {
                c.root?.view
                    .environmentObjectIfPossible(c)
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
        .modifier(route.modifier)
    }
    
    private func modalView(_ route: RouteWrapper) -> some View {
        Group {
            if let view = route.view {
                view
                    .environmentObjectIfPossible(route.parent)
            } else if let c = route.coordinator as? NavigationCoordinator {
                NavigationCoordinatorRootView(coordinator: c)
                    .environmentObjectIfPossible(c)
            } else if let c = route.coordinator as? TabCoordinator {
                TabCoordinatorRootView(coordinator: c)
                    .environmentObjectIfPossible(c)
            } else if let c = route.coordinator as? RootCoordinator {
                RootCoordinatorRootView(coordinator: c)
                    .environmentObjectIfPossible(c)
            } else {
                EmptyView()
            }
        }
        .modifier(route.modifier)
    }
    
    var body: some View {
        NavigationStack(path: coordinator.combinedStack) {
            coordinator.root?.view?
                .environmentObjectIfPossible(coordinator)
                .navigationDestination(for: RouteWrapper.self, destination: wrappedView)
        }
        .sheet(item: coordinator.sharedSheet, onDismiss: coordinator.onDismiss, content: modalView)
#if os(iOS)
        .fullScreenCover(item: coordinator.sharedFullScreenCover, onDismiss: coordinator.onDismiss, content: modalView)
#endif
    }
}
