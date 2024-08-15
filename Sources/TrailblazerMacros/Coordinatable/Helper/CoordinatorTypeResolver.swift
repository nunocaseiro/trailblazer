//
//  CoordinatorTypeResolver.swift
//  
//
//  Created by Alexandr Valíček on 12.08.2024.
//

import SwiftSyntax

struct CoordinatorTypeResolver {
    static func resolve(from classDecl: ClassDeclSyntax) -> CoordinatorType {
        guard let inheritanceClause = classDecl.inheritanceClause else {
            return .none
        }

        let inheritedTypes = inheritanceClause.inheritedTypes.compactMap {
            $0.type.as(IdentifierTypeSyntax.self)?.name.text
        }

        if inheritedTypes.contains("TabCoordinator") {
            return .tab
        } else if inheritedTypes.contains("RootCoordinator") {
            return .root
        } else if inheritedTypes.contains("NavigationCoordinator") {
            return .navigation
        } else {
            return .none
        }
    }
}

enum CoordinatorType: String {
    case navigation = "NavigationCoordinatable"
    case root = "RootCoordinatable"
    case tab = "TabCoordinatable"
    case none = "None"
}
