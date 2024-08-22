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
    
    /// Pushes a new route onto the navigation stack and allows nested coordination.
    /// - Parameters:
    ///   - route: The route to be added to the stack.
    ///   - modifier: An optional closure to modify the view associated with the route.
    ///   - nested: A closure that receives the coordinator of type T and allows nested routing.
    /// - Returns: Self for method chaining.
    @discardableResult
    func route<T>(
        to route: Routes,
        with modifier: ((any View) -> any View)? = nil,
        nested perform: ((T) -> Void)? = nil
    ) -> Self where T: Coordinatable {
        let wrapper = prepareWrapper(for: route, with: modifier)
        stack.append(wrapper)
        
        if let coordinator = wrapper.coordinator as? T,
           let perform = perform {
            perform(coordinator)
        }
        
        notifyStackChanged()
        
        return self
    }
    
    /// Pushes a new route onto the navigation stack and allows nested coordination without view modification.
    /// - Parameters:
    ///   - route: The route to be added to the stack.
    ///   - nested: A closure that receives the coordinator of type T and allows nested routing.
    /// - Returns: Self for method chaining.
    @discardableResult
    func route<T>(
        to route: Routes,
        nested perform: ((T) -> Void)? = nil
    ) -> Self where T: Coordinatable {
        let wrapper = prepareWrapper(for: route, with: nil)
        stack.append(wrapper)
        
        if let coordinator = wrapper.coordinator as? T,
           let perform = perform {
            perform(coordinator)
        }
        
        notifyStackChanged()
        
        return self
    }
    
    /// Presents a route modally as either a sheet or full-screen cover.
    /// - Parameters:
    ///   - route: The route to be presented.
    ///   - presentationType: The type of modal presentation (.sheet or .fullScreenCover).
    /// - Returns: Self for method chaining.
    @discardableResult
    func present(
        _ route: Routes,
        as presentationType: PresentationType
    ) -> Self {
        let wrapper = prepareWrapper(for: route, with: nil)
        wrapper.coordinator?.hasLayerNavigationCoordinator = false
        
        self.onDismiss = nil
        
        switch presentationType {
        case .sheet:
            self.presentedSheet = wrapper
        case .fullScreenCover:
            self.presentedFullScreenCover = wrapper
        }
        
        notifyStackChanged()
        return self
    }
    
    /// Presents a route modally as either a sheet or full-screen cover.
    /// - Parameters:
    ///   - route: The route to be presented.
    ///   - presentationType: The type of modal presentation (.sheet or .fullScreenCover).
    ///   - modifier: An optional closure to modify the view associated with the route.
    /// - Returns: Self for method chaining.
    @discardableResult
    func present(
        _ route: Routes,
        as presentationType: PresentationType,
        with modifier: ((any View) -> any View)? = nil
    ) -> Self {
        let wrapper = prepareWrapper(for: route, with: modifier)
        wrapper.coordinator?.hasLayerNavigationCoordinator = false
        
        self.onDismiss = nil
        
        switch presentationType {
        case .sheet:
            self.presentedSheet = wrapper
        case .fullScreenCover:
            self.presentedFullScreenCover = wrapper
        }
        
        notifyStackChanged()
        return self
    }
    
    /// Presents a route modally as either a sheet or full-screen cover.
    /// - Parameters:
    ///   - route: The route to be presented.
    ///   - presentationType: The type of modal presentation (.sheet or .fullScreenCover).
    ///   - onDismiss: An optional closure to be called when the presented view is dismissed.
    /// - Returns: Self for method chaining.
    @discardableResult
    func present(
        _ route: Routes,
        as presentationType: PresentationType,
        onDismiss: (() -> Void)? = nil
    ) -> Self {
        let wrapper = prepareWrapper(for: route, with: nil)
        wrapper.coordinator?.hasLayerNavigationCoordinator = false
        
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
    
    /// Presents a route modally and allows nested coordination.
    /// - Parameters:
    ///   - route: The route to be presented.
    ///   - presentationType: The type of modal presentation (.sheet or .fullScreenCover).
    ///   - nested: A closure that receives the coordinator of type T and allows nested routing.
    /// - Returns: Self for method chaining.
    @discardableResult
    func present<T>(
        _ route: Routes,
        as presentationType: PresentationType,
        nested perform: ((T) -> Void)? = nil
    ) -> Self where T: Coordinatable {
        let wrapper = prepareWrapper(for: route, with: nil)
        wrapper.coordinator?.hasLayerNavigationCoordinator = false
        
        self.onDismiss = onDismiss
        
        switch presentationType {
        case .sheet:
            self.presentedSheet = wrapper
        case .fullScreenCover:
            self.presentedFullScreenCover = wrapper
        }
        
        if let coordinator = wrapper.coordinator as? T,
           let perform = perform {
            perform(coordinator)
        }
        
        notifyStackChanged()
        return self
    }
    
    /// Presents a route modally and allows nested coordination.
    /// - Parameters:
    ///   - route: The route to be presented.
    ///   - presentationType: The type of modal presentation (.sheet or .fullScreenCover).
    ///   - onDismiss: An optional closure to be called when the presented view is dismissed.
    ///   - nested: A closure that receives the coordinator of type T and allows nested routing.
    /// - Returns: Self for method chaining.
    @discardableResult
    func present<T>(
        _ route: Routes,
        as presentationType: PresentationType,
        onDismiss: (() -> Void)? = nil,
        nested perform: ((T) -> Void)? = nil
    ) -> Self where T: Coordinatable {
        let wrapper = prepareWrapper(for: route, with: nil)
        wrapper.coordinator?.hasLayerNavigationCoordinator = false
        
        self.onDismiss = onDismiss
        
        switch presentationType {
        case .sheet:
            self.presentedSheet = wrapper
        case .fullScreenCover:
            self.presentedFullScreenCover = wrapper
        }
        
        if let coordinator = wrapper.coordinator as? T,
           let perform = perform {
            perform(coordinator)
        }
        
        notifyStackChanged()
        return self
    }
    
    /// Presents a route modally and allows nested coordination.
    /// - Parameters:
    ///   - route: The route to be presented.
    ///   - presentationType: The type of modal presentation (.sheet or .fullScreenCover).
    ///   - modifier: An optional closure to modify the view associated with the route.
    ///   - nested: A closure that receives the coordinator of type T and allows nested routing.
    /// - Returns: Self for method chaining.
    @discardableResult
    func present<T>(
        _ route: Routes,
        as presentationType: PresentationType,
        with modifier: ((any View) -> any View)? = nil,
        nested perform: ((T) -> Void)? = nil
    ) -> Self where T: Coordinatable {
        let wrapper = prepareWrapper(for: route, with: modifier)
        wrapper.coordinator?.hasLayerNavigationCoordinator = false
        
        self.onDismiss = onDismiss
        
        switch presentationType {
        case .sheet:
            self.presentedSheet = wrapper
        case .fullScreenCover:
            self.presentedFullScreenCover = wrapper
        }
        
        if let coordinator = wrapper.coordinator as? T,
           let perform = perform {
            perform(coordinator)
        }
        
        notifyStackChanged()
        return self
    }
    
    /// Presents a route modally and allows nested coordination.
    /// - Parameters:
    ///   - route: The route to be presented.
    ///   - presentationType: The type of modal presentation (.sheet or .fullScreenCover).
    ///   - onDismiss: An optional closure to be called when the presented view is dismissed.
    ///   - modifier: An optional closure to modify the view associated with the route.
    ///   - nested: A closure that receives the coordinator of type T and allows nested routing.
    /// - Returns: Self for method chaining.
    @discardableResult
    func present<T>(
        _ route: Routes,
        as presentationType: PresentationType,
        onDismiss: (() -> Void)? = nil,
        with modifier: ((any View) -> any View)? = nil,
        nested perform: ((T) -> Void)? = nil
    ) -> Self where T: Coordinatable {
        let wrapper = prepareWrapper(for: route, with: modifier)
        wrapper.coordinator?.hasLayerNavigationCoordinator = false
        
        self.onDismiss = onDismiss
        
        switch presentationType {
        case .sheet:
            self.presentedSheet = wrapper
        case .fullScreenCover:
            self.presentedFullScreenCover = wrapper
        }
        
        if let coordinator = wrapper.coordinator as? T,
           let perform = perform {
            perform(coordinator)
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
        } else if stack.isEmpty && parent != nil {
            dismissCoordinator()
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
    
    /// Clears the entire navigation stack and dismisses any modals, returning to the root view, then allows nested coordination.
    /// - Parameter nested: A closure that receives the root coordinator of type T and allows nested routing.
    /// - Returns: Self for method chaining.
    @discardableResult
    func popToRoot<T>(nested perform: ((T) -> Void)? = nil) -> Self where T: Coordinatable {
        sharedFullScreenCover.wrappedValue = nil
        sharedSheet.wrappedValue = nil
        combinedStack.wrappedValue.removeAll()
        
        if let rootCoordinator = root?.coordinator as? T,
           let perform = perform {
            perform(rootCoordinator)
        }
        
        notifyStackChanged()
        return self
    }
    
    /// Pops the navigation stack to the first occurrence of the specified route.
    /// - Parameter route: The route to pop to.
    /// - Returns: Self for method chaining.
    @discardableResult
    func popToFirst(route: Routes) -> Self {
        if let index = stack.firstIndex(where: {
            return String(describing: $0.route.self) == String(describing: route.self)
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
    
    /// Pops the navigation stack to the first occurrence of the specified route, then allows nested coordination.
    /// - Parameters:
    ///   - route: The route to pop to.
    ///   - nested: A closure that receives the coordinator of type T for the popped-to route and allows nested routing.
    /// - Returns: Self for method chaining.
    @discardableResult
    func popToFirst<T>(route: Routes, nested perform: ((T) -> Void)? = nil) -> Self where T: Coordinatable {
        if let index = stack.firstIndex(where: {
            return String(describing: $0.route.self) == String(describing: route.self)
        }) {
            if index != stack.count - 1 {
                sharedFullScreenCover.wrappedValue = nil
                sharedSheet.wrappedValue = nil
            }
            
            stack = Array(stack.prefix(through: index))
            
            if let coordinator = stack.last?.coordinator as? T,
               let perform = perform {
                perform(coordinator)
            }
            
            notifyStackChanged()
        }
        return self
    }
    
    /// Pops the navigation stack to the last occurrence of the specified route.
    /// - Parameter route: The route to pop to.
    /// - Returns: Self for method chaining.
    @discardableResult
    func popToLast(route: Routes) -> Self {
        if let index = stack.lastIndex(where: {
            return String(describing: $0.route.self) == String(describing: route.self)
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
    
    /// Pops the navigation stack to the last occurrence of the specified route, then allows nested coordination.
    /// - Parameters:
    ///   - route: The route to pop to.
    ///   - nested: A closure that receives the coordinator of type T for the popped-to route and allows nested routing.
    /// - Returns: Self for method chaining.
    @discardableResult
    func popToLast<T>(route: Routes, nested perform: ((T) -> Void)? = nil) -> Self where T: Coordinatable {
        if let index = stack.lastIndex(where: {
            return String(describing: $0.route.self) == String(describing: route.self)
        }) {
            if index != stack.count - 1 {
                sharedFullScreenCover.wrappedValue = nil
                sharedSheet.wrappedValue = nil
            }
            
            stack = Array(stack.prefix(through: index))
            
            if let coordinator = stack.last?.coordinator as? T,
               let perform = perform {
                perform(coordinator)
            }
            
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
    
    /// Sets a new root view for the navigation stack and allows nested coordination.
    /// - Parameters:
    ///   - route: The route to set as the new root.
    ///   - nested: A closure that receives the coordinator of type T and allows nested routing.
    /// - Returns: Self for method chaining.
    @discardableResult
    func setRoot<T>(_ route: Routes, nested perform: ((T) -> Void)? = nil) -> Self where T: Coordinatable {
        let wrapper = prepareWrapper(for: route, with: nil)
        root = wrapper
        
        if let coordinator = wrapper.coordinator as? T,
           let perform = perform {
            perform(coordinator)
        }
        
        notifyStackChanged()
        return self
    }
    
    /// Returns the topmost route wrapper without modifying the stack.
    /// - Returns: The topmost RouteWrapper, or nil if the stack is empty.
    func peek() -> RouteWrapper? {
        return combinedStack.wrappedValue.last ?? root
    }
}
