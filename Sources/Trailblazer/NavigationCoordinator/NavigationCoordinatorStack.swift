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
            if let nestedCoordinator = wrapper.coordinator as? NavigationCoordinator {
                combined.append(contentsOf: nestedCoordinator.flattenedStack)
            }
        }
        return combined
    }
    
    public var combinedStack: Binding<[RouteWrapper]> {
        Binding(
            get: { self.flattenedStack },
            set: { newRoutes in self.updateStack(with: newRoutes) }
        )
    }
    
    func updateStack(with newRoutes: [RouteWrapper]) {
        func update(_ coordinator: NavigationCoordinator, from index: Int) -> Int {
            var i = index
            
            coordinator.stack = newRoutes[i...].prefix { route in
                guard let existing = coordinator.stack.first(where: { $0.id == route.id }) else { return false }
                
                i += 1
                
                if let nested = existing.coordinator as? NavigationCoordinator {
                    i = update(nested, from: i)
                }
                
                return true
            }
            
            return i
        }
        
        _ = update(self, from: 0)
    }
}
