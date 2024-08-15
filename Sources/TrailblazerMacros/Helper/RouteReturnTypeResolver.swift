//
//  RouteReturnTypeResolver.swift
//  
//
//  Created by Alexandr Valíček on 14.08.2024.
//

import SwiftSyntax

struct RouteReturnTypeResolver {
    static func resolve(from clause: ReturnClauseSyntax?) -> RouteReturnType {
        if let tupleType = clause?.type.as(TupleTypeSyntax.self) {
            if tupleType.elements.count > 2 { return .none }
            
            guard let tabContent = tupleType.elements.first?.type.as(SomeOrAnyTypeSyntax.self) else { return .none }
            guard let tabItem = tupleType.elements.last?.type.as(SomeOrAnyTypeSyntax.self) else { return .none }
            
            let resolvedTabContent = resolveSomeOrAnyReturnType(clause: tabContent)
            let resolvedTabItem = resolveSomeOrAnyReturnType(clause: tabItem)
            
            if resolvedTabItem != .view { return .none }
            if resolvedTabContent == .coordinatable && resolvedTabItem == .view { return .coordinatableView }
            if resolvedTabContent == .view && resolvedTabItem == .view { return .viewView }
        }
        if let singleType = clause?.type.as(SomeOrAnyTypeSyntax.self) {
            return resolveSomeOrAnyReturnType(clause: singleType)
        }
        
        return .none
    }
}

extension RouteReturnTypeResolver {
    private static func resolveSomeOrAnyReturnType(clause: SomeOrAnyTypeSyntax) -> RouteReturnType {
        let someOrAnySpecifier = clause.someOrAnySpecifier
        
        switch someOrAnySpecifier.tokenKind {
        case .keyword(.some):
            if let identifier = clause.constraint.as(IdentifierTypeSyntax.self)?.name.text, identifier.contains("View") {
                return .view
            }
        case .keyword(.any):
            if let identifier = clause.constraint.as(IdentifierTypeSyntax.self)?.name.text, identifier.contains("Coordinatable") {
                return .coordinatable
            }
        default: break
        }
        
        return .none
    }
}

enum RouteReturnType {
    case none
    case view
    case coordinatable
    case viewView
    case coordinatableView
}
