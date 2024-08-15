//
//  RouteMethodExtractor.swift
//  
//
//  Created by Alexandr Valíček on 14.08.2024.
//

import SwiftSyntax

struct RouteMethodExtractor {
    static func extract(from classDecl: ClassDeclSyntax) -> [FunctionDeclSyntax] {
        classDecl.memberBlock.members
            .compactMap { $0.decl.as(FunctionDeclSyntax.self) }
            .filter { $0.attributes.contains { $0.as(AttributeSyntax.self)?.attributeName.as(IdentifierTypeSyntax.self)?.name.text == "Route" } }
    }
}
