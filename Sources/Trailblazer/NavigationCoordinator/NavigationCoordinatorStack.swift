//
//  NavigationCoordinatorStack.swift
//  
//
//  Created by Alexandr Valíček on 29.07.2024.
//

import SwiftUI

extension NavigationCoordinator {
    public var flattenedStack: [RouteWrapper] {
        var combined: [RouteWrapper] = []
        
        for wrapper in stack {
            combined.append(wrapper)
            combined.append(contentsOf: flattenedStackForCoordinator(wrapper.coordinator))
        }
        
        return combined
    }

    private func flattenedStackForCoordinator(_ coordinator: any Coordinatable) -> [RouteWrapper] {
        switch coordinator {
        case let navigationCoordinator as NavigationCoordinator:
            return navigationCoordinator.flattenedStack
        case let tabCoordinator as TabCoordinator:
            return flattenedStackForCoordinator(tabCoordinator.selectedTab?.coordinator)
        case let rootCoordinator as RootCoordinator:
            return flattenedStackForCoordinator(rootCoordinator.root?.coordinator)
        default:
            return []
        }
    }

    private func flattenedStackForCoordinator(_ coordinator: (any Coordinatable)?) -> [RouteWrapper] {
        guard let coordinator = coordinator else { return [] }
        return flattenedStackForCoordinator(coordinator)
    }
    
    public var combinedStack: Binding<[RouteWrapper]> {
        Binding(
            get: { self.flattenedStack },
            set: { newRoutes in self.updateStack(with: newRoutes) }
        )
    }
    
    func updateStack(with newRoutes: [RouteWrapper]) {
        func update(_ coordinator: any AnyCoordinator, from index: inout Int) -> Int {
            switch coordinator {
            case let navigationCoordinator as NavigationCoordinator:
                navigationCoordinator.stack = newRoutes[index...].prefix { route in
                    guard let existing = navigationCoordinator.stack.first(where: { $0.id == route.id }) else { return false }
                    
                    index += 1
                    index = update(existing.coordinator as! (any AnyCoordinator), from: &index)
                    return true
                }
            case let tabCoordinator as TabCoordinator:
                if let selectedTab = tabCoordinator.selectedTab {
                    index = update(selectedTab.coordinator as! (any AnyCoordinator), from: &index)
                }
            case let rootCoordinator as RootCoordinator:
                if let root = rootCoordinator.root {
                    index = update(root.coordinator as! (any AnyCoordinator), from: &index)
                }
            default:
                break
            }
            return index
        }
        
        var startIndex = 0
        _ = update(self, from: &startIndex)
    }
}
