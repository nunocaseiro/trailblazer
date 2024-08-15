// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

@attached(extension,
          conformances: NavigationCoordinatable, TabCoordinatable, RootCoordinatable,
          names: named(ReferencedRoutes),
          named(Routes),
          named(getReferencedRoute(from:)),
          named(createRouteWrapper(from:)),
          named(flattenedStack)
)
public macro Coordinatable() = #externalMacro(module: "TrailblazerMacros", type: "CoordinatableMacro")

@attached(peer)
public macro Route() = #externalMacro(module: "TrailblazerMacros", type: "RouteMacro")
