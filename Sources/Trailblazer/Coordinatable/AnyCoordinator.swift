//
//  AnyCoordinator.swift
//  
//
//  Created by Alexandr Valíček on 30.07.2024.
//

import SwiftUI

protocol AnyCoordinator: ObservableObject {
    associatedtype Body: View
    var parent: (any Coordinatable)? { get set }
    var hasLayerNavigationCoordinator: Bool { get set }
    var view: Body { get }
    var id: UUID { get }
}
