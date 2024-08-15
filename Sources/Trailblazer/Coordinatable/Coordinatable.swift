//
//  Coordinatable.swift
//
//
//  Created by Alexandr Valíček on 23.07.2024.
//

import SwiftUI
import Combine

public protocol Coordinatable: ObservableObject, Identifiable {
    associatedtype Routes
    
    var parent: (any Coordinatable)? { get set }
    var hasLayerNavigationCoordinator: Bool { get set }
    var objectWillChange: ObservableObjectPublisher { get }
    
    func createRouteWrapper(from: Routes) -> any RouteWrappable
    
    var id: UUID { get }
}

extension Coordinatable {
    func notifyStackChanged() {
        objectWillChange.send()
        parent?.notifyStackChanged()
    }
}

public extension Coordinatable {
    func dismissCoordinator() {
        if let parent = parent as? NavigationCoordinator {
            if parent.presentedSheet?.coordinator?.id == self.id {
                parent.presentedSheet = nil
            } else if parent.presentedFullScreenCover?.coordinator?.id == self.id {
                parent.presentedFullScreenCover = nil
            } else {
                parent.stack.removeAll(where: { $0.coordinator?.id == self.id })
            }
        }
    }
}
