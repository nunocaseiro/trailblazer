//
//  TabCoordinatorRootView.swift
//  
//
//  Created by Alexandr Valíček on 30.07.2024.
//

import SwiftUI

internal struct TabCoordinatorRootView: View {
    @StateObject var coordinator: TabCoordinator
    
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
                TabCoordinatorRootView(coordinator: c)
            } else if let c = route.coordinator as? RootCoordinator, let view = c.view as? AnyView {
                view
                    .environmentObjectIfPossible(c)
            } else {
                EmptyView()
            }
        }
    }
    
    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            ForEach(coordinator.tabs, id: \.self) { tab in
                wrappedView(tab)
                    .environmentObjectIfPossible(coordinator)
                    .tabItem {
                        tab.tabItem
                    }
                    .tag(tab)
            }
        }
    }
}
