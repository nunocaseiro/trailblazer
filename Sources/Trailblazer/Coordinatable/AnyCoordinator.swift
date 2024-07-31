//
//  AnyCoordinator.swift
//  
//
//  Created by Alexandr Valíček on 30.07.2024.
//

import SwiftUI

protocol AnyCoordinator: ObservableObject {
    var parent: (any Coordinatable)? { get set }
    associatedtype Body: View
    var view: Body { get }
}

extension AnyCoordinator {
    func parentInTree<T: AnyCoordinator>(ofType type: T.Type) -> Bool {
        if let parent = parent as? (any AnyCoordinator) {
            if parent is T {
                return true
            } else {
                return parent.parentInTree(ofType: type)
            }
        }
        
        return false
    }
}
