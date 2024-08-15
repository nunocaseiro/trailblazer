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
            } else if let c = route.coordinator as? RootCoordinator {
                c.view
                    .environmentObjectIfPossible(c)
            } else {
                EmptyView()
            }
        }
    }
    
    var body: some View {
        TabView(selection: selectedTabBinding) {
            ForEach(coordinator.tabs) { tab in
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

extension TabCoordinatorRootView {
    private var selectedTabBinding: Binding<TabRouteWrapper> {
        Binding(
            get: { self.coordinator.selectedTab ?? self.coordinator.tabs.first ?? TabRouteWrapper(parent: AnyCoordinatableBox(), route: (Any).self, view: EmptyView(), tabItem: EmptyView()) },
            set: { self.coordinator.selectedTab = $0 }
        )
    }
}
