//
//  TabCoordinator.swift
//  
//
//  Created by Alexandr Valíček on 30.07.2024.
//

import SwiftUI

open class TabCoordinator: AnyCoordinator {
    public let id: UUID = UUID()
    @Published public var tabs: [TabRouteWrapper] = []
    public var parent: (any Coordinatable)?
    public var hasLayerNavigationCoordinator: Bool = false
    public var root: TabRouteWrapper?
    @Published public var selectedTab: TabRouteWrapper?
    
    public var view: some View {
        TabCoordinatorRootView(coordinator: self)
    }
    
    public init() { }
}
