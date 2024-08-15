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
}
