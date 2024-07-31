//
//  CoordinatableMacro.swift
//
//
//  Created by Alexandr Valíček on 24.07.2024.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct CoordinatableMacro: ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        guard let classDecl = declaration.as(ClassDeclSyntax.self) else {
            throw MacroError.notAClass
        }
        
        let className = classDecl.name.text
        
        let routeMethods = classDecl.memberBlock.members
            .compactMap { $0.decl.as(FunctionDeclSyntax.self) }
            .filter { $0.attributes.contains { $0.as(AttributeSyntax.self)?.attributeName.as(IdentifierTypeSyntax.self)?.name.text == "Route" } }
        
        let extensionContent = generateExtensionContent(className: className, routeMethods: routeMethods)
        
        let extensionDeclString = """
        extension \(type.trimmed): NavigationCoordinatable {
        \(extensionContent.split(separator: "\n").map { "    \($0)" }.joined(separator: "\n"))
        }
        """

        let extensionDecl = try ExtensionDeclSyntax(SyntaxNodeString(stringLiteral: extensionDeclString))

        return [extensionDecl]
    }
}
