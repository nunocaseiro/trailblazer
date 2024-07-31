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
        nestedGetter: @escaping (NavigationCoordinator) -> Binding<RouteWrapper?>
    ) -> Binding<RouteWrapper?> {
        Binding(
            get: {
                presented() ?? self.stack.lazy
                    .compactMap { $0.coordinator as? NavigationCoordinator }
                    .compactMap { nestedGetter($0).wrappedValue }
                    .first
            },
            set: { newValue in
                if let newValue = newValue {
                    if presented() == nil {
                        setPresented(newValue)
                    } else {
                        self.stack.lazy
                            .compactMap { $0.coordinator as? NavigationCoordinator }
                            .first
                            .map { nestedGetter($0).wrappedValue = newValue }
                    }
                } else {
                    setPresented(nil)
                    self.stack.forEach {
                        ($0.coordinator as? NavigationCoordinator)
                            .map { nestedGetter($0).wrappedValue = nil }
                    }
                }
            }
        )
    }
    
    public var sharedSheet: Binding<RouteWrapper?> {
        sharedPresentation(
            presented: { self.presentedSheet },
            setPresented: { self.presentedSheet = $0 },
            nestedGetter: { $0.sharedSheet }
        )
    }
    
    public var sharedFullScreenCover: Binding<RouteWrapper?> {
        sharedPresentation(
            presented: { self.presentedFullScreenCover },
            setPresented: { self.presentedFullScreenCover = $0 },
            nestedGetter: { $0.sharedFullScreenCover }
        )
    }
}
