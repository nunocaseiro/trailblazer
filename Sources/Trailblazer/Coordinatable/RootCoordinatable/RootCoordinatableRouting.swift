//
//  RootCoordinatableRouting.swift
//  
//
//  Created by Alexandr Valíček on 06.08.2024.
//

import SwiftUI

public extension RootCoordinatable {
    /// Sets a new root view.
    /// - Parameter route: The route to set as the new root.
    /// - Returns: Self for method chaining.
    @discardableResult
    func setRoot(_ route: Routes) -> Self {
        let wrapper = prepareWrapper(for: route)
        root = wrapper
        notifyStackChanged()
        return self
    }
    
    /// Sets a new root view and allows nested coordination.
    /// - Parameters:
    ///   - route: The route to set as the new root.
    ///   - nested: A closure that receives the coordinator of type T and allows nested routing.
    /// - Returns: Self for method chaining.
    @discardableResult
    func setRoot<T>(_ route: Routes, nested perform: ((T) -> Void)? = nil) -> Self where T: Coordinatable {
        let wrapper = prepareWrapper(for: route)
        root = wrapper
        
        if let coordinator = wrapper.coordinator as? T,
           let perform = perform {
            perform(coordinator)
        }
        
        notifyStackChanged()
        return self
    }
}
