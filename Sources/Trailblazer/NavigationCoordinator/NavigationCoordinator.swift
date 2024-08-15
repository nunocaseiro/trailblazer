//
//  NavigationCoordinator.swift
//
//
//  Created by Alexandr Valíček on 23.07.2024.
//

import SwiftUI

open class NavigationCoordinator: AnyCoordinator {
    public let id: UUID = UUID()
    @Published public var stack: [RouteWrapper] = []
    public var root: RouteWrapper?
    public var parent: (any Coordinatable)?
    public var hasLayerNavigationCoordinator: Bool = false
    @Published public var presentedSheet: RouteWrapper?
    @Published public var presentedFullScreenCover: RouteWrapper?
    public var onDismiss: (() -> Void)? = nil
    
    public var view: some View {
        NavigationCoordinatorRootView(coordinator: self)
    }
    
    public init() { }
}
