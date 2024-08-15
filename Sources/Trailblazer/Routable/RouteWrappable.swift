//
//  RouteWrappable.swift
//  
//
//  Created by Alexandr Valíček on 30.07.2024.
//

import SwiftUI

public protocol RouteWrappable: Identifiable, Hashable {
    var id: UUID { get }
    var parent: any Coordinatable { get }
    var route: Any { get }
    var coordinator: (any Coordinatable)? { get }
    var view: AnyView? { get }
    var modifier: AnyViewModifier { get }
}
