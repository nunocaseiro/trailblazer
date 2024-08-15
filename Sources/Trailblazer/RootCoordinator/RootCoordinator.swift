//
//  RootCoordinator.swift
//  
//
//  Created by Alexandr Valíček on 06.08.2024.
//

import SwiftUI

open class RootCoordinator: AnyCoordinator {
    public let id: UUID = UUID()
    public var root: RouteWrapper?
    public var parent: (any Coordinatable)?
    public var hasLayerNavigationCoordinator: Bool = false
    
    public var view: some View {
        RootCoordinatorRootView(coordinator: self)
    }
    
    public init() { }
}
