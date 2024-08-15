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
import SwiftDiagnostics

public struct RouteMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let funcDecl = declaration.as(FunctionDeclSyntax.self) else {
            throw RouteMacroError.notAFunction
        }
        
        let returnClause = funcDecl.signature.returnClause
        let resolverReturnType = RouteReturnTypeResolver.resolve(from: returnClause)
        
        // On versions before XCode 16.0 lexicalContext returns [], rendering checks to return false positives
        if !context.lexicalContext.isEmpty {
            guard let classDecl = context.lexicalContext.last?.as(ClassDeclSyntax.self) else {
                throw RouteMacroError.notInsideClass
            }
            
            guard hasCoordinatableAttribute(classDecl: classDecl) else {
                throw RouteMacroError.missingCoordinatableAttribute
            }
            
            if let _ = returnClause, resolverReturnType == .none {
                if inherits(classDecl: classDecl, dependency: "TabCoordinator") {
                    throw RouteMacroError.invalidRouteReturnTypeTab(
                        methodName: funcDecl.name.text,
                        returnType: returnClause?.type.trimmedDescription ?? String()
                    )
                } else {
                    throw RouteMacroError.invalidRouteReturnTypeGeneric(
                        methodName: funcDecl.name.text,
                        returnType: returnClause?.type.trimmedDescription ?? String()
                    )
                }
            }
        // Fallback limited checks for versions of XCode before 16.0
        } else {
            if let _ = returnClause, resolverReturnType == .none {
                throw RouteMacroError.invalidRouteReturnTypeFallback(
                    methodName: funcDecl.name.text,
                    returnType: returnClause?.type.trimmedDescription ?? String()
                )
            }
        }
        
        return []
    }
}

extension RouteMacro {
    private static func hasCoordinatableAttribute(classDecl: ClassDeclSyntax) -> Bool {
        return classDecl.attributes.contains { attr in
            if case .attribute(let attribute) = attr,
               let identifierType = attribute.attributeName.as(IdentifierTypeSyntax.self),
               identifierType.name.text == "Coordinatable" {
                return true
            }
            return false
        }
    }
    
    private static func inherits(classDecl: ClassDeclSyntax, dependency: String) -> Bool {
        guard let inheritanceClause = classDecl.inheritanceClause else {
            return false
        }
        
        return inheritanceClause.inheritedTypes.contains { type in
            type.type.description.contains(dependency)
        }
    }
}
