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
            if let view = route.view, let v = route.extractCoordinator(route.route) {
                view
                    .environmentObjectIfPossible(v)
            } else if let c = route.coordinator as? NavigationCoordinator, let view = c.root?.view {
                view
                    .environmentObjectIfPossible(c)
            }  else {
                EmptyView()
            }
        }
    }
    
    private func modalView(_ route: RouteWrapper) -> some View {
        Group {
            if let view = route.view, let v = route.extractCoordinator(route.route) {
                view
                    .environmentObjectIfPossible(v)
                    .modifier(route.modifier)
            } else if let c = route.coordinator as? NavigationCoordinator {
                NavigationCoordinatorRootView(coordinator: c)
                    .environmentObjectIfPossible(c)
                    .modifier(route.modifier)
            } else {
                EmptyView()
            }
        }
    }
    
    var body: some View {
        NavigationStack(path: coordinator.combinedStack) {
            coordinator.root?.view
                .environmentObjectIfPossible(coordinator)
                .navigationDestination(for: RouteWrapper.self, destination: wrappedView)
        }
        .sheet(item: coordinator.sharedSheet, onDismiss: coordinator.onDismiss, content: modalView)
#if os(iOS)
        .fullScreenCover(item: coordinator.sharedFullScreenCover, onDismiss: coordinator.onDismiss, content: modalView)
#endif
    }
}
