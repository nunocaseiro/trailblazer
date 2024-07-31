//
//  RouteMacro.swift
//
//
//  Created by Alexandr Valíček on 24.07.2024.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct RouteMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let funcDecl = declaration.as(FunctionDeclSyntax.self) else {
            throw MacroError.notAFunction
        }

        let returnType = funcDecl.signature.returnClause?.type.description ?? "Void"
        let trimmedReturnType = returnType.trimmingCharacters(in: .whitespaces)
        
        if !returnType.contains("some View") && !returnType.contains("any Coordinatable") {
            throw MacroError.invalidRouteReturnType(methodName: funcDecl.name.text, returnType: trimmedReturnType)
        }
        
        return []
    }
}
