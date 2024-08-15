//
//  NavigationCoordinatorPresentation.swift
//  
//
//  Created by Alexandr Valíček on 29.07.2024.
//

import SwiftUI

extension NavigationCoordinator {
    private func sharedPresentation(
        presented: @escaping () -> RouteWrapper?,
        setPresented: @escaping (RouteWrapper?) -> Void,
        nestedGetter: @escaping (any Coordinatable) -> Binding<RouteWrapper?>
    ) -> Binding<RouteWrapper?> {
        Binding(
            get: {
                presented() ?? self.stack.lazy
                    .compactMap { $0.coordinator }
                    .compactMap { nestedGetter($0).wrappedValue }
                    .first
            },
            set: { newValue in
                if let newValue = newValue {
                    if presented() == nil {
                        setPresented(newValue)
                    } else {
                        self.stack.lazy
                            .compactMap { $0.coordinator }
                            .first
                            .map { nestedGetter($0).wrappedValue = newValue }
                    }
                } else {
                    setPresented(nil)
                    self.stack.forEach {
                        if let c = $0.coordinator {
                            nestedGetter(c).wrappedValue = nil
                        }
                    }
                }
            }
        )
    }
    
    public var sharedSheet: Binding<RouteWrapper?> {
        sharedPresentation(
            presented: { self.presentedSheet },
            setPresented: { self.presentedSheet = $0 },
            nestedGetter: getSharedSheet
        )
    }
    
    public var sharedFullScreenCover: Binding<RouteWrapper?> {
        sharedPresentation(
            presented: { self.presentedFullScreenCover },
            setPresented: { self.presentedFullScreenCover = $0 },
            nestedGetter: getSharedFullScreenCover
        )
    }
    
    private func getSharedSheet(_ coordinator: any Coordinatable) -> Binding<RouteWrapper?> {
        switch coordinator {
        case let navigationCoordinator as NavigationCoordinator:
            return navigationCoordinator.sharedSheet
        case let tabCoordinator as TabCoordinator:
            return getSharedSheet(tabCoordinator.selectedTab?.coordinator)
        case let rootCoordinator as RootCoordinator:
            return getSharedSheet(rootCoordinator.root?.coordinator)
        default:
            return .constant(nil)
        }
    }
    
    private func getSharedFullScreenCover(_ coordinator: any Coordinatable) -> Binding<RouteWrapper?> {
        switch coordinator {
        case let navigationCoordinator as NavigationCoordinator:
            return navigationCoordinator.sharedFullScreenCover
        case let tabCoordinator as TabCoordinator:
            return getSharedFullScreenCover(tabCoordinator.selectedTab?.coordinator)
        case let rootCoordinator as RootCoordinator:
            return getSharedFullScreenCover(rootCoordinator.root?.coordinator)
        default:
            return .constant(nil)
        }
    }
    
    private func getSharedSheet(_ coordinator: (any Coordinatable)?) -> Binding<RouteWrapper?> {
        guard let coordinator = coordinator else { return .constant(nil) }
        return getSharedSheet(coordinator)
    }
    
    private func getSharedFullScreenCover(_ coordinator: (any Coordinatable)?) -> Binding<RouteWrapper?> {
        guard let coordinator = coordinator else { return .constant(nil) }
        return getSharedFullScreenCover(coordinator)
    }
}
