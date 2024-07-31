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
    associatedtype ReferencedRoutes

    var parent: (any Coordinatable)? { get set }
    var objectWillChange: ObservableObjectPublisher { get }

    func getReferencedRoute(from: Routes) -> ReferencedRoutes
    func createRouteWrapper(from: ReferencedRoutes) -> any RouteWrappable
}

extension Coordinatable {
    func notifyStackChanged() {
        objectWillChange.send()
        parent?.notifyStackChanged()
    }
}
