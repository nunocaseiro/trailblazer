//
//  NavigationCoordinatableRouting.swift
//  
//
//  Created by Alexandr Valíček on 29.07.2024.
//

import SwiftUI

public extension NavigationCoordinatable {
    /// Pushes a new route onto the navigation stack.
    /// - Parameters:
    ///   - route: The route to be added to the stack.
    ///   - modifier: An optional closure to modify the view associated with the route.
    /// - Returns: Self for method chaining.
    @discardableResult
    func route(
        to route: Routes,
        with modifier: ((any View) -> any View)? = nil
    ) -> Self {
        let wrapper = prepareWrapper(for: route, with: modifier)
        stack.append(wrapper)
        
        notifyStackChanged()
        return self
    }
    
    /// Presents a route modally as either a sheet or full-screen cover.
    /// - Parameters:
    ///   - route: The route to be presented.
    ///   - presentationType: The type of modal presentation (.sheet or .fullScreenCover).
    ///   - onDismiss: An optional closure to be called when the presented view is dismissed.
    ///   - modifier: An optional closure to modify the view associated with the route.
    /// - Returns: Self for method chaining.
    @discardableResult
    func present(
        _ route: Routes,
        as presentationType: PresentationType,
        onDismiss: (() -> Void)? = nil,
        with modifier: ((any View) -> any View)? = nil
    ) -> Self {
        let wrapper = prepareWrapper(for: route, with: modifier)
        self.onDismiss = onDismiss
        
        switch presentationType {
        case .sheet:
            self.presentedSheet = wrapper
        case .fullScreenCover:
            self.presentedFullScreenCover = wrapper
        }
        
        notifyStackChanged()
        return self
    }

    /// Removes the topmost item from the navigation stack or dismisses the current modal.
    /// - Returns: Self for method chaining.
    @discardableResult
    func pop() -> Self {
        if sharedFullScreenCover.wrappedValue != nil {
            sharedFullScreenCover.wrappedValue = nil
        } else if sharedSheet.wrappedValue != nil {
            sharedSheet.wrappedValue = nil
        } else if !stack.isEmpty {
            stack.removeLast()
        }
        
        notifyStackChanged()
        return self
    }
    
    
    /// Clears the entire navigation stack and dismisses any modals, returning to the root view.
    /// - Returns: Self for method chaining.
    @discardableResult
    func popToRoot() -> Self {
        sharedFullScreenCover.wrappedValue = nil
        sharedSheet.wrappedValue = nil
        combinedStack.wrappedValue.removeAll()
        
        notifyStackChanged()
        return self
    }
    
    /// Pops the navigation stack to the first occurrence of the specified route.
    /// - Parameter route: The route to pop to.
    /// - Returns: Self for method chaining.
    @discardableResult
    func popToFirst(route: Routes) -> Self {
        let concreteRoute = getReferencedRoute(from: route)
        if let index = stack.firstIndex(where: {
            return String(describing: $0.route.self) == String(describing: concreteRoute.self)
        }) {
            if index != stack.count - 1 {
                sharedFullScreenCover.wrappedValue = nil
                sharedSheet.wrappedValue = nil
            }
            
            stack = Array(stack.prefix(through: index))
            notifyStackChanged()
        }
        return self
    }
    
    /// Pops the navigation stack to the last occurrence of the specified route.
    /// - Parameter route: The route to pop to.
    /// - Returns: Self for method chaining.
    @discardableResult
    func popToLast(route: Routes) -> Self {
        let concreteRoute = getReferencedRoute(from: route)
        if let index = stack.lastIndex(where: {
            return String(describing: $0.route.self) == String(describing: concreteRoute.self)
        }) {
            if index != stack.count - 1 {
                sharedFullScreenCover.wrappedValue = nil
                sharedSheet.wrappedValue = nil
            }
            
            stack = Array(stack.prefix(through: index))
            notifyStackChanged()
        }
        return self
    }
    
    /// Sets a new root view for the navigation stack.
    /// - Parameter route: The route to set as the new root.
    /// - Returns: Self for method chaining.
    @discardableResult
    func setRoot(_ route: Routes) -> Self {
        let wrapper = prepareWrapper(for: route, with: nil)
        root = wrapper
        notifyStackChanged()
        return self
    }
    
    /// Returns the topmost route wrapper without modifying the stack.
    /// - Returns: The topmost RouteWrapper, or nil if the stack is empty.
    func peek() -> RouteWrapper? {
        return combinedStack.wrappedValue.last ?? root
    }
}

extension NavigationCoordinatable {
    private func prepareWrapper(for route: Routes, with modifier: ((any View) -> any View)? = nil) -> RouteWrapper {
        let concreteRoute = getReferencedRoute(from: route)
        if var wrapper = createRouteWrapper(from: concreteRoute) as? RouteWrapper {
            wrapper.modifier = modifier.map { m in
                AnyViewModifier { AnyView(m($0)) }
            } ?? .identity
            
            if let coordinator = wrapper.coordinator {
                coordinator.parent = self
            }
            
            return wrapper
        } else {
            return RouteWrapper(route: concreteRoute, view: EmptyView())
        }
    }
}
