//
//  RouteWrapper.swift
//
//
//  Created by Alexandr Valíček on 23.07.2024.
//

import SwiftUI

public struct RouteWrapper: RouteWrappable {
    public let id: UUID
    public let parent: any Coordinatable
    public let route: Any
    public var coordinator: (any Coordinatable)?
    public let view: AnyView?
    public var modifier: AnyViewModifier
    
    public init<T: View>(parent: any Coordinatable, route: Any, view: T) {
        self.id = UUID()
        self.parent = parent
        self.route = route
        self.coordinator = nil
        self.view = AnyView(view)
        self.modifier = AnyViewModifier.identity
    }
    
    public init(parent: any Coordinatable, route: Any, coordinator: any Coordinatable) {
        self.id = UUID()
        self.parent = parent
        self.route = route
        self.coordinator = coordinator
        self.view = nil
        self.modifier = AnyViewModifier.identity
    }

    public static func == (lhs: RouteWrapper, rhs: RouteWrapper) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
