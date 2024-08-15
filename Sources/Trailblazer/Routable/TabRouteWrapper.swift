//
//  TabRouteWrapper.swift
//  
//
//  Created by Alexandr Valíček on 30.07.2024.
//

import SwiftUI

public struct TabRouteWrapper: RouteWrappable {
    public let id: UUID
    public let parent: any Coordinatable
    public let route: Any
    public var _coordinator: (() -> (any Coordinatable))?
    public var view: AnyView?
    public let tabItem: AnyView
    public let modifier: AnyViewModifier = AnyViewModifier.identity
    
    public var coordinator: (any Coordinatable)? {
        _coordinator?()
    }
    
    public init<T: View>(parent: any Coordinatable, route: Any, view: T, tabItem: T) {
        self.id = UUID()
        self.parent = parent
        self.route = route
        self._coordinator = nil
        self.view = AnyView(view)
        self.tabItem = AnyView(tabItem)
    }
    
    public init<T: View>(parent: any Coordinatable, route: Any, coordinatorFactory: @escaping () -> any Coordinatable, tabItem: T) {
        self.id = UUID()
        self.parent = parent
        self.route = route
        self._coordinator = coordinatorFactory
        self.view = nil
        self.tabItem = AnyView(tabItem)
    }

    public static func == (lhs: TabRouteWrapper, rhs: TabRouteWrapper) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
