//
//  RouteWrappable.swift
//  
//
//  Created by Alexandr Valíček on 30.07.2024.
//

import SwiftUI

public protocol RouteWrappable: Identifiable, Hashable {
    var id: UUID { get }
    var route: Any { get }
    var coordinator: (any Coordinatable)? { get set }
    var view: AnyView? { get }
}

extension RouteWrappable {
    func extractCoordinator(_ value: Any) -> (any AnyCoordinator)? {
        return Mirror(reflecting: value).children.first.flatMap { child in
            (Mirror(reflecting: child.value).displayStyle == .tuple
             ? Mirror(reflecting: child.value).children.first?.value as Any
             : child.value) as Any as? (any AnyCoordinator)
        }
    }
}
